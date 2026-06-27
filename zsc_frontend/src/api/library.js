import request from '@/utils/request'

const baseUrl = '/api/library'

export function getDashboard() {
  return request({
    url: `${baseUrl}/dashboard`,
    method: 'get'
  })
}

export function queryBooks(data) {
  return request({
    url: `${baseUrl}/books/query`,
    method: 'post',
    data
  })
}

export function getBook(bookId) {
  return request({
    url: `${baseUrl}/books/${bookId}`,
    method: 'get'
  })
}

export function saveBook(data) {
  return request({
    url: `${baseUrl}/books`,
    method: 'post',
    data
  })
}

export function deleteBook(bookId) {
  return request({
    url: `${baseUrl}/books/${bookId}`,
    method: 'delete'
  })
}

export function queryReaders(data) {
  return request({
    url: `${baseUrl}/readers/query`,
    method: 'post',
    data
  })
}

export function getReader(readerId) {
  return request({
    url: `${baseUrl}/readers/${readerId}`,
    method: 'get'
  })
}

export function getReaderByMobile(mobile) {
  return request({
    url: `${baseUrl}/readers/by-mobile/${mobile}`,
    method: 'get'
  })
}

export function getOrCreateReader(userId, readerName) {
  return request({
    url: `${baseUrl}/readers/by-user/${userId}`,
    method: 'get',
    params: readerName ? { readerName } : {}
  })
}

export function getReaderSummary(readerId) {
  return request({
    url: `${baseUrl}/readers/${readerId}/summary`,
    method: 'get'
  })
}

export function saveReader(data) {
  return request({
    url: `${baseUrl}/readers`,
    method: 'post',
    data
  })
}

export function deleteReader(readerId) {
  return request({
    url: `${baseUrl}/readers/${readerId}`,
    method: 'delete'
  })
}

export function saveAddress(data) {
  return request({
    url: `${baseUrl}/addresses`,
    method: 'post',
    data
  })
}

export function deleteAddress(addressId) {
  return request({
    url: `${baseUrl}/addresses/${addressId}`,
    method: 'delete'
  })
}

export function getReaderAddresses(readerId) {
  return request({
    url: `${baseUrl}/addresses/by-reader/${readerId}`,
    method: 'get'
  })
}

export function getAddress(addressId) {
  return request({
    url: `${baseUrl}/addresses/${addressId}`,
    method: 'get'
  })
}

export function borrowOnline(data) {
  return request({
    url: `${baseUrl}/borrow/online`,
    method: 'post',
    data
  })
}

export function joinQueue(data) {
  return request({
    url: `${baseUrl}/queues/join`,
    method: 'post',
    data
  })
}

export function queryQueues(data) {
  return request({
    url: `${baseUrl}/queues/query`,
    method: 'post',
    data
  })
}

export function handleQueue(data) {
  return request({
    url: `${baseUrl}/queues/handle`,
    method: 'post',
    data
  })
}

export function queryOrders(data) {
  return request({
    url: `${baseUrl}/orders/query`,
    method: 'post',
    data
  })
}

export function confirmFulfillment(data) {
  return request({
    url: `${baseUrl}/orders/confirm-fulfillment`,
    method: 'post',
    data
  })
}

export function requestReturn(data) {
  return request({
    url: `${baseUrl}/orders/request-return`,
    method: 'post',
    data
  })
}

export function confirmReturn(data) {
  return request({
    url: `${baseUrl}/orders/confirm-return`,
    method: 'post',
    data
  })
}

export function payCompensation(data) {
  return request({
    url: `${baseUrl}/orders/pay-compensation`,
    method: 'post',
    data
  })
}

export function payFee(data) {
  return request({
    url: `${baseUrl}/fees/pay`,
    method: 'post',
    data
  })
}

export function getReaderDeliveries(readerId) {
  return request({
    url: `${baseUrl}/deliveries/by-reader/${readerId}`,
    method: 'get'
  })
}

export function getOrderDeliveries(orderId) {
  return request({
    url: `${baseUrl}/deliveries/by-order/${orderId}`,
    method: 'get'
  })
}

export function getReaderFees(readerId) {
  return request({
    url: `${baseUrl}/fees/by-reader/${readerId}`,
    method: 'get'
  })
}

export function getActiveRule() {
  return request({
    url: `${baseUrl}/rules/active`,
    method: 'get'
  })
}

export function saveRule(data) {
  return request({
    url: `${baseUrl}/rules`,
    method: 'post',
    data
  })
}
