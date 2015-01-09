require "ostruct"

class SocketRouter
  @routes = {}

  def self.draw(&block)
    instance_eval &block
  end

  %w(get post put delete).each do |method|
    define_singleton_method method do |options|
      options.each do |k, v|
        @routes[{:method => method.to_sym, :url => k}] = v
      end
    end
  end

  def self.route(method, url)
    OpenStruct.new @routes[{:method => method.downcase.to_sym, :url => url}]
  end
end

SocketRouter.draw do
  get "/rooms" => {:controller => RoomsController, :action => "index"}
  post "/rooms" => {:controller => RoomsController, :action => "create"}
end
