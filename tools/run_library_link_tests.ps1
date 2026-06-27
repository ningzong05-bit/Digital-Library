$ErrorActionPreference = 'Stop'
$base='http://localhost:8081'
$stamp=Get-Date -Format 'yyyyMMddHHmmss'
$failures = New-Object System.Collections.Generic.List[string]
$results = New-Object System.Collections.Generic.List[string]
$script:currentStep = 'startup'
function Json($obj){ $obj | ConvertTo-Json -Depth 20 }
function Add-Result($name,$ok,$detail='') { if($ok){ $script:results.Add("PASS $name $detail") } else { $script:results.Add("FAIL $name $detail"); $script:failures.Add("$name $detail") } }
function TextOf($value) {
  if ($null -eq $value) { return '' }
  if ($value -is [string]) { return $value }
  return ($value | ConvertTo-Json -Depth 8 -Compress)
}
function ShortText($value) {
  $text = TextOf $value
  return $text.Substring(0, [Math]::Min(120, $text.Length))
}
function Invoke-Json($method,$path,$body=$null,$token=$null,$expectOk=$true){
  $headers=@{}
  if($token){ $headers.Authorization = "Bearer $token" }
  try {
    if($null -eq $body){
      $res = Invoke-RestMethod -Method $method -Uri ($base+$path) -Headers $headers -ContentType 'application/json'
    } else {
      $jsonBody = Json $body
      $utf8Body = [System.Text.Encoding]::UTF8.GetBytes($jsonBody)
      $res = Invoke-RestMethod -Method $method -Uri ($base+$path) -Headers $headers -ContentType 'application/json; charset=utf-8' -Body $utf8Body
    }
    if($expectOk -and ($res.PSObject.Properties.Name -contains 'code') -and $res.code -ne 200){ throw "step=$script:currentStep business code $($res.code): $($res.message)" }
    return $res
  } catch {
    if($expectOk){ throw }
    return $_.Exception.Message
  }
}
function Login($u,$p){
  $r = Invoke-Json 'POST' '/login' @{ username=$u; password=$p; code=''; uuid='' }
  if(-not $r.token){ throw "login failed for $u" }
  return $r.token
}
function EnsureReaderCapacity($readerId) {
  $script:currentStep = "prepare reader $readerId capacity"
  $r = (Invoke-Json 'GET' "/api/library/readers/$readerId" $null $adminToken).data
  Invoke-Json 'POST' '/api/library/readers' @{
    readerId=$r.readerId
    userId=$r.userId
    readerName=$r.readerName
    mobile=$r.mobile
    city=$r.city
    annualExpireDate='2027-12-31'
    depositBalance=500.00
    depositFrozen=0
    usedOutboundCount=0
    usedInboundCount=0
    maxOutboundCount=50
    maxInboundCount=50
    maxBorrowCount=50
    status='NORMAL'
  } $adminToken | Out-Null
}
function PrepareReaderForRegression($readerId) {
  $script:currentStep = "prepare reader $readerId clean compensation"
  Invoke-Json 'POST' '/api/library/fees/pay' @{ readerId=$readerId; feeType='DEPOSIT_RECHARGE'; amount=10000.00; payMethod='TEST'; remark='回归测试清理历史待赔偿' } $adminToken | Out-Null
  $pending = Invoke-Json 'POST' '/api/library/orders/query' @{ pageNum=1; pageSize=100; readerId=$readerId; orderStatus='COMPENSATION_PENDING' } $adminToken
  foreach($order in @($pending.data.list)){
    Invoke-Json 'POST' '/api/library/orders/pay-compensation' @{ orderId=$order.orderId; payMethod='DEPOSIT'; remark='回归测试清理历史待赔偿' } $adminToken | Out-Null
  }
  $script:currentStep = "prepare reader $readerId address room"
  $addresses = Invoke-Json 'GET' "/api/library/addresses/by-reader/$readerId" $null $adminToken
  $addressRows = @($addresses.data)
  while($addressRows.Count -ge 5) {
    $victim = $addressRows[$addressRows.Count - 1]
    Invoke-Json 'DELETE' "/api/library/addresses/$($victim.addressId)" $null $adminToken | Out-Null
    $addresses = Invoke-Json 'GET' "/api/library/addresses/by-reader/$readerId" $null $adminToken
    $addressRows = @($addresses.data)
  }
}
function SaveBook($isbn,$name,$total,$available='__same__',$status='ENABLED'){
  if($available -eq '__same__'){ $available = $total }
  Invoke-Json 'POST' '/api/library/books' @{ isbn=$isbn; bookName=$name; author='Codex Test'; publisher='链路测试出版社'; categoryName='链路测试'; totalCount=$total; availableCount=$available; status=$status } $adminToken | Out-Null
  $q=Invoke-Json 'POST' '/api/library/books/query' @{ pageNum=1; pageSize=20; isbn=$isbn } $adminToken
  return @($q.data.list)[0]
}
function QueryOrdersByBook($bookId,$readerId=$null,$status=$null){
  $body=@{ pageNum=1; pageSize=50; bookId=$bookId }
  if($readerId){ $body.readerId=$readerId }
  if($status){ $body.orderStatus=$status }
  $q=Invoke-Json 'POST' '/api/library/orders/query' $body $adminToken
  return @($q.data.list)
}
function QueryQueuesByBook($bookId,$readerId=$null,$status=$null){
  $body=@{ pageNum=1; pageSize=50; bookId=$bookId }
  if($readerId){ $body.readerId=$readerId }
  if($status){ $body.queueStatus=$status }
  $q=Invoke-Json 'POST' '/api/library/queues/query' $body $adminToken
  return @($q.data.list)
}
$script:currentStep = 'login admin'
$adminToken = Login 'admin' 'admin123'
$script:currentStep = 'login zhangsan'
$readerToken = Login 'zhangsan' 'reader123'
Add-Result 'login-admin-reader' ($adminToken -and $readerToken) "admin/zhangsan"

$script:currentStep = 'get reader 1'
$reader = Invoke-Json 'GET' '/api/library/readers/1' $null $adminToken
Add-Result 'reader-zhangsan-exists' ($reader.data.readerId -eq 1) "readerId=$($reader.data.readerId)"
$script:currentStep = 'get active rule'
$activeRule = Invoke-Json 'GET' '/api/library/rules/active' $null $adminToken
$libraryCity = $activeRule.data.libraryCity
PrepareReaderForRegression 1
PrepareReaderForRegression 4
EnsureReaderCapacity 1
EnsureReaderCapacity 4

# Address validation: library city should reject other cities and accept same city.
$script:currentStep = 'save bad city address'
$badMsg = Invoke-Json 'POST' '/api/library/addresses' @{ readerId=1; receiverName='Zhangsan'; receiverMobile='13900000000'; city='OtherCity'; district='Test'; detailAddress='bad-address'; defaultFlag=0; status='ENABLED' } $readerToken $false
Add-Result 'address-cross-city-rejected' ((TextOf $badMsg) -match '同城|所在城市|当前仅支持|城市|500') (ShortText $badMsg)
$goodAddrBody=@{ readerId=1; receiverName='Zhangsan'; receiverMobile='13900000000'; city=$libraryCity; district='Test'; detailAddress="link-test-address-$stamp"; defaultFlag=1; status='ENABLED' }
$script:currentStep = 'save good address'
$goodAddrResult = Invoke-Json 'POST' '/api/library/addresses' $goodAddrBody $readerToken $false
$script:currentStep = 'query reader addresses'
$addrList=Invoke-Json 'GET' '/api/library/addresses/by-reader/1' $null $readerToken
$addr=@($addrList.data | Where-Object { $_.detailAddress -eq $goodAddrBody.detailAddress })[0]
if(-not $addr){ $addr=@($addrList.data | Sort-Object addressId -Descending)[0] }
Add-Result 'address-same-city-saved' ($goodAddrResult.code -eq 200 -and $addr.addressId -gt 0) "addressId=$($addr.addressId) response=$(ShortText $goodAddrResult)"

# Duplicate ISBN merge.
$isbnDup="CODEx-DUP-$stamp"
$b1=SaveBook $isbnDup "重复ISBN合并-$stamp" 2
$b2=SaveBook $isbnDup "重复ISBN合并-$stamp" 3
$qDup=Invoke-Json 'POST' '/api/library/books/query' @{ pageNum=1; pageSize=20; isbn=$isbnDup } $adminToken
$dupRows=@($qDup.data.list)
$dup=$dupRows[0]
Add-Result 'book-duplicate-isbn-merged' ($dupRows.Count -eq 1 -and $dup.totalCount -eq 5 -and $dup.availableCount -eq 5) "rows=$($dupRows.Count), total=$($dup.totalCount), available=$($dup.availableCount)"

# Active borrow blocks offline/delete.
$activeBook=SaveBook "CODEx-ACT-$stamp" "在借阻止下架删除-$stamp" 1
$borrow=Invoke-Json 'POST' '/api/library/borrow/online' @{ readerId=1; bookId=$activeBook.bookId; borrowType='SELF_PICKUP'; remark='active blocker test' } $readerToken
$activeOrder=$borrow.data.order
$offlineMsg=Invoke-Json 'POST' '/api/library/books' @{ bookId=$activeBook.bookId; isbn=$activeBook.isbn; bookName=$activeBook.bookName; author=$activeBook.author; publisher=$activeBook.publisher; categoryName=$activeBook.categoryName; totalCount=$activeBook.totalCount; availableCount=$activeBook.availableCount; status='DISABLED' } $adminToken $false
$deleteMsg=Invoke-Json 'DELETE' "/api/library/books/$($activeBook.bookId)" $null $adminToken $false
Add-Result 'active-book-offline-blocked' ((TextOf $offlineMsg) -match '订单|排队|不能|无法|进行中') (ShortText $offlineMsg)
Add-Result 'active-book-delete-blocked' ((TextOf $deleteMsg) -match '订单|排队|不能|无法|进行中') (ShortText $deleteMsg)

# Self pickup full borrow-return lifecycle.
Invoke-Json 'POST' '/api/library/orders/confirm-fulfillment' @{ orderId=$activeOrder.orderId; fulfillmentDate='2026-06-25 21:20:00'; remark='馆员确认取书' } $adminToken | Out-Null
Invoke-Json 'POST' '/api/library/orders/request-return' @{ orderId=$activeOrder.orderId; returnType='LIBRARY_RETURN'; remark='读者到馆还书' } $readerToken | Out-Null
$ret=Invoke-Json 'POST' '/api/library/orders/confirm-return' @{ orderId=$activeOrder.orderId; libraryReceiveDate='2026-06-25 21:25:00'; damageStatus='NORMAL'; compensationAmount=0; remark='验收正常' } $adminToken
$activeAfter=@(QueryOrdersByBook $activeBook.bookId 1 'RETURNED') | Select-Object -First 1
Add-Result 'self-pickup-returned-recorded' ($activeAfter.orderStatus -eq 'RETURNED') "orderId=$($activeOrder.orderId) status=$($activeAfter.orderStatus)"

# Returned book can be deleted.
$delReturned=Invoke-Json 'DELETE' "/api/library/books/$($activeBook.bookId)" $null $adminToken
Add-Result 'returned-book-delete-allowed' ($delReturned.code -eq 200) "bookId=$($activeBook.bookId)"

# Library ship lifecycle and delivery records.
$shipBook=SaveBook "CODEx-SHIP-$stamp" "邮寄履约-$stamp" 1
$shipBorrow=Invoke-Json 'POST' '/api/library/borrow/online' @{ readerId=1; bookId=$shipBook.bookId; borrowType='LIBRARY_SHIP'; addressId=$addr.addressId; receiverAddress="$libraryCity link-test-address"; remark='ship borrow' } $readerToken
$shipOrder=$shipBorrow.data.order
Invoke-Json 'POST' '/api/library/orders/confirm-fulfillment' @{ orderId=$shipOrder.orderId; fulfillmentDate='2026-06-25 21:30:00'; trackingNo="SF$stamp"; carrierName='顺丰'; freightAmount=8.5; remark='馆方向读者寄出' } $adminToken | Out-Null
$delivs=Invoke-Json 'GET' "/api/library/deliveries/by-order/$($shipOrder.orderId)" $null $adminToken
$libOut=@($delivs.data | Where-Object { $_.deliveryType -eq 'LIBRARY_OUT' -and $_.deliveryStatus -eq 'SHIPPED' })
Add-Result 'ship-fulfillment-delivery-recorded' ($libOut.Count -ge 1) "orderId=$($shipOrder.orderId) deliveryCount=$($delivs.data.Count)"
Invoke-Json 'POST' '/api/library/orders/request-return' @{ orderId=$shipOrder.orderId; returnType='USER_SHIP'; userShipBackDate='2026-06-25 21:35:00'; trackingNo="YT$stamp"; carrierName='圆通'; remark='读者寄回' } $readerToken | Out-Null
Invoke-Json 'POST' '/api/library/orders/confirm-return' @{ orderId=$shipOrder.orderId; libraryReceiveDate='2026-06-25 21:40:00'; damageStatus='DAMAGED'; compensationAmount=1.00; remark='轻微破损扣费' } $adminToken | Out-Null
$fees=Invoke-Json 'GET' '/api/library/fees/by-reader/1' $null $adminToken
$feeHit=@($fees.data | Where-Object { $_.orderId -eq $shipOrder.orderId -and $_.feeType -eq 'COMPENSATION' })
Add-Result 'ship-return-compensation-fee-recorded' ($feeHit.Count -ge 1) "feeCount=$($feeHit.Count)"

# Compensation pending lifecycle: insufficient deposit blocks payment and new borrowing, recharge then deposit payment closes order.
$compBook=SaveBook "CODEx-COMP-$stamp" "赔偿待缴-$stamp" 1
$compBorrow=Invoke-Json 'POST' '/api/library/borrow/online' @{ readerId=1; bookId=$compBook.bookId; borrowType='SELF_PICKUP'; remark='compensation pending test' } $readerToken
$compOrder=$compBorrow.data.order
Invoke-Json 'POST' '/api/library/orders/confirm-fulfillment' @{ orderId=$compOrder.orderId; fulfillmentDate='2026-06-25 21:41:00'; remark='comp pickup' } $adminToken | Out-Null
$readerBeforeComp = (Invoke-Json 'GET' '/api/library/readers/1' $null $adminToken).data
Invoke-Json 'POST' '/api/library/readers' @{
  readerId=$readerBeforeComp.readerId
  userId=$readerBeforeComp.userId
  readerName=$readerBeforeComp.readerName
  mobile=$readerBeforeComp.mobile
  city=$readerBeforeComp.city
  annualExpireDate='2027-12-31'
  depositBalance=50.00
  depositFrozen=0
  usedOutboundCount=$readerBeforeComp.usedOutboundCount
  usedInboundCount=$readerBeforeComp.usedInboundCount
  maxOutboundCount=$readerBeforeComp.maxOutboundCount
  maxInboundCount=$readerBeforeComp.maxInboundCount
  maxBorrowCount=$readerBeforeComp.maxBorrowCount
  status='NORMAL'
} $adminToken | Out-Null
Invoke-Json 'POST' '/api/library/orders/request-return' @{ orderId=$compOrder.orderId; returnType='LIBRARY_RETURN'; remark='comp return' } $readerToken | Out-Null
$compReturn=Invoke-Json 'POST' '/api/library/orders/confirm-return' @{ orderId=$compOrder.orderId; libraryReceiveDate='2026-06-25 21:42:00'; damageStatus='DAMAGED'; compensationAmount=120.00; remark='赔偿待缴' } $adminToken
$effectiveReader=(Invoke-Json 'GET' '/api/library/readers/1' $null $readerToken).data
$payFail=Invoke-Json 'POST' '/api/library/orders/pay-compensation' @{ orderId=$compOrder.orderId; payMethod='DEPOSIT'; remark='余额不足测试' } $readerToken $false
$blockedBorrow=Invoke-Json 'POST' '/api/library/borrow/online' @{ readerId=1; bookId=$compBook.bookId; borrowType='SELF_PICKUP'; remark='should block while pending compensation' } $readerToken $false
Add-Result 'compensation-pending-created' ($compReturn.data.returnResult -eq 'COMPENSATION_PENDING') "orderId=$($compOrder.orderId)"
Add-Result 'compensation-pending-reader-not-normal' ($effectiveReader.status -ne 'NORMAL') "status=$($effectiveReader.status)"
Add-Result 'compensation-pay-insufficient-blocked' ((TextOf $payFail) -match '押金|余额|充值|补差价') (ShortText $payFail)
Add-Result 'compensation-pending-blocks-new-borrow' ((TextOf $blockedBorrow) -match '赔偿|暂不能|不可|500') (ShortText $blockedBorrow)
Invoke-Json 'POST' '/api/library/fees/pay' @{ readerId=1; feeType='DEPOSIT_RECHARGE'; amount=300.00; payMethod='TEST'; remark='赔偿测试充值' } $adminToken | Out-Null
$payOk=Invoke-Json 'POST' '/api/library/orders/pay-compensation' @{ orderId=$compOrder.orderId; payMethod='DEPOSIT'; remark='押金补缴赔偿' } $readerToken
$paidOrder=@(QueryOrdersByBook $compBook.bookId 1 'RETURNED') | Select-Object -First 1
Add-Result 'compensation-deposit-payment-closes-order' ($payOk.data.payResult -eq 'RETURNED' -and $paidOrder.orderStatus -eq 'RETURNED') "orderId=$($compOrder.orderId)"

# Queue auto conversion after returned copy becomes available. Use reader 4 as holder, reader 1 queues.
$queueBook=SaveBook "CODEx-QUEUE-$stamp" "排队转单-$stamp" 1
$holderBorrow=Invoke-Json 'POST' '/api/library/borrow/online' @{ readerId=4; bookId=$queueBook.bookId; borrowType='SELF_PICKUP'; remark='holder borrow' } $adminToken
$holderOrder=$holderBorrow.data.order
$queueJoin=Invoke-Json 'POST' '/api/library/queues/join' @{ readerId=1; bookId=$queueBook.bookId; borrowType='SELF_PICKUP'; remark='waiting for return' } $readerToken
$queueId=$queueJoin.data.queue.queueId
Invoke-Json 'POST' '/api/library/orders/confirm-fulfillment' @{ orderId=$holderOrder.orderId; fulfillmentDate='2026-06-25 21:45:00'; remark='holder pickup' } $adminToken | Out-Null
Invoke-Json 'POST' '/api/library/orders/request-return' @{ orderId=$holderOrder.orderId; returnType='LIBRARY_RETURN'; remark='holder return' } $adminToken | Out-Null
Invoke-Json 'POST' '/api/library/orders/confirm-return' @{ orderId=$holderOrder.orderId; libraryReceiveDate='2026-06-25 21:50:00'; damageStatus='NORMAL'; compensationAmount=0; remark='return triggers queue' } $adminToken | Out-Null
$converted=@(QueryQueuesByBook $queueBook.bookId 1 'CONVERTED') | Select-Object -First 1
$newOrder=@(QueryOrdersByBook $queueBook.bookId 1 'WAIT_PICKUP') | Select-Object -First 1
Add-Result 'queue-auto-converted-to-order' ($converted.queueStatus -eq 'CONVERTED' -and $newOrder.orderStatus -eq 'WAIT_PICKUP') "queueId=$queueId orderId=$($newOrder.orderId)"

# Queue manual cancellation endpoint.
$cancelBook=SaveBook "CODEx-QCANCEL-$stamp" "排队取消-$stamp" 0 0
$qCancel=Invoke-Json 'POST' '/api/library/queues/join' @{ readerId=4; bookId=$cancelBook.bookId; borrowType='SELF_PICKUP'; remark='manual cancel test' } $adminToken
$qCancelId=$qCancel.data.queue.queueId
Invoke-Json 'POST' '/api/library/queues/handle' @{ queueId=$qCancelId; queueStatus='CANCELLED'; remark='管理员取消测试' } $adminToken | Out-Null
$qCancelled=@(QueryQueuesByBook $cancelBook.bookId 4 'CANCELLED') | Select-Object -First 1
Add-Result 'queue-manual-cancelled' ($qCancelled.queueStatus -eq 'CANCELLED') "queueId=$qCancelId"

# Reader-facing borrow records include returned/borrowing/wait statuses.
$readerOrders=Invoke-Json 'POST' '/api/library/orders/query' @{ pageNum=1; pageSize=100; readerId=1 } $readerToken
$statuses=@($readerOrders.data.list | ForEach-Object { $_.orderStatus } | Select-Object -Unique)
Add-Result 'reader-borrow-history-has-all-status-records' (($statuses -contains 'RETURNED') -and (($statuses -contains 'WAIT_PICKUP') -or ($statuses -contains 'BORROWING') -or ($statuses -contains 'RETURNING'))) ("statuses=" + ($statuses -join ','))

# Smoke new query endpoints do not resolve as static resources.
$rDelivs=Invoke-Json 'GET' '/api/library/deliveries/by-reader/1' $null $adminToken
$rFees=Invoke-Json 'GET' '/api/library/fees/by-reader/1' $null $adminToken
Add-Result 'new-query-endpoints-active' (($rDelivs.code -eq 200) -and ($rFees.code -eq 200)) "deliveries=$($rDelivs.data.Count) fees=$($rFees.data.Count)"

$results | ForEach-Object { Write-Output $_ }
if($failures.Count -gt 0){ Write-Output "FAILURES: $($failures.Count)"; exit 1 } else { Write-Output 'ALL_LINK_TESTS_PASSED' }
