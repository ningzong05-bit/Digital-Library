exports.handler = async function handler(event) {
  const baseUrl = process.env.RAILWAY_API_URL;

  if (!baseUrl) {
    return {
      statusCode: 502,
      headers: { "content-type": "application/json; charset=utf-8" },
      body: JSON.stringify({ msg: "RAILWAY_API_URL is not configured" })
    };
  }

  const path = (event.queryStringParameters && event.queryStringParameters.path) || "";
  const target = new URL(path.replace(/^\/+/, ""), baseUrl.endsWith("/") ? baseUrl : `${baseUrl}/`);
  const search = new URLSearchParams(event.queryStringParameters || {});
  search.delete("path");
  target.search = search.toString();

  const headers = { ...event.headers };
  delete headers.host;
  delete headers["content-length"];

  const init = {
    method: event.httpMethod,
    headers
  };

  if (!["GET", "HEAD"].includes(event.httpMethod)) {
    init.body = event.isBase64Encoded
      ? Buffer.from(event.body || "", "base64")
      : event.body || "";
  }

  const response = await fetch(target, init);
  const buffer = Buffer.from(await response.arrayBuffer());
  const contentType = response.headers.get("content-type") || "";
  const isText = /^(text\/|application\/json|application\/xml|application\/javascript)/i.test(contentType);

  return {
    statusCode: response.status,
    headers: {
      "content-type": contentType || "application/octet-stream"
    },
    body: isText ? buffer.toString("utf8") : buffer.toString("base64"),
    isBase64Encoded: !isText
  };
};
