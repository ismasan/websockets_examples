require 'rubygems'
require "bundler/setup"

require 'em-websocket'

class Channel
  
  def initialize
    @sockets = []
  end
  
  def subscribe(socket)
    @sockets << socket
  end
  
  def unsubscribe(socket)
    @sockets.delete socket
  end
  
  def send_message(msg)
    @sockets.each do |socket|
      socket.send msg
    end
  end
end

EventMachine.run {
  
  @channel = Channel.new
  
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080, :debug => true) do |socket|
    socket.onopen {
      @channel.subscribe socket
      @channel.send_message 'User connected'
    }
    socket.onmessage { |msg|
      @channel.send_message msg
    }
    socket.onclose {
      @channel.unsubscribe socket
    }
  end
  
}