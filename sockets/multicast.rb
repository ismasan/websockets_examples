require 'rubygems'
require "bundler/setup"

require 'em-websocket'

$LOAD_PATH.unshift(File.dirname(File.expand_path(__FILE__)) + '/../' )

require 'config'

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
  
  EventMachine::WebSocket.start(:host => IP, :port => 8080, :debug => true) do |socket|
    socket.onopen {
      puts 'Socket connected'
      @channel.subscribe socket
    }
    socket.onmessage { |msg|
      @channel.send_message msg
    }
    socket.onclose {
      puts 'Socket closed'
      @channel.unsubscribe socket
    }
    socket.onerror {
      puts 'ERRORRRRR'
    }
  end
  
}