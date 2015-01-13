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

  def controller_action(controller, action, data)
    controller.send(action, OpenStruct.new(data))
  end

  def each_connection(room, &block)
    room.map(&:socket).each(&block)
  end
end
