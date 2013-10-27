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
    @sockets.each { |s| safe_write(s, update) }
  end

  def safe_write(socket, update)
    socket.write update
    rescue Errno::EPIPE; disconnect(socket)
  end
  private :safe_write

  def disconnect(socket)
    disconnect_message socket
    @sockets.delete    socket
    return false
  end
  private :disconnect

  def disconnect_message(socket)
    socket_info = Socket.unpack_sockaddr_in(socket.local_address)
    puts "A screen client disconnected: #{socket_info}"
  end
  private :disconnect_message

end
