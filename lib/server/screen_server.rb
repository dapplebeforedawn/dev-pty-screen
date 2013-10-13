require 'socket'
require 'celluloid'
Thread.abort_on_exception = true

class ScreenServer
  include Celluloid

  def initialize port
    @port    = port
    @sockets = []
  end

  def listen
    Thread.new do
      Socket.tcp_server_loop @port, &register
    end
  end

  def register
    ->(socket, client_info) {
      socket.sync = true
      @sockets << socket
    }
  end

  # screen_server.async.write
  def write update
    @sockets.each {|s| s.write update }
  end

end
