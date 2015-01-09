require "json"

module SocketHTTP
  def socket_response(http_method, http_endpoint, body)
    JSON.generate({
      headers: {
        method: http_method,
        url: http_endpoint
      },
      body: body
    })
  end
end
