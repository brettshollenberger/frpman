require "ostruct"

class SocketRouter
  @routes = {}

  def self.draw(&block)
    instance_eval &block
  end

  def self.get(options)
    options.each do |k, v|
      @routes[{:method => :get, :url => k}] = v
    end

    puts @routes
  end

  def self.route(method, url)
    OpenStruct.new @routes[{:method => method.downcase.to_sym, :url => url}]
  end
end

SocketRouter.draw do
  get "/rooms" => {:controller => RoomsController, :action => "index"}
end
