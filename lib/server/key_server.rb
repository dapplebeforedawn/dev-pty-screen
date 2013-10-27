require 'socket'
require 'celluloid'
Thread.abort_on_exception = true

class KeyServer
  READSIZE = 4096
  include Celluloid

  def initialize port, callback
    @port     = port
    @callback = callback
  end

  # screen_server.listen
  def listen
    Thread.new do
      Socket.tcp_server_loop @port, &register
    end
  end

  def register
    ->(socket, client_info) {
      socket.sync = true
      Thread.new do
        loop {
          key_data = read_key(socket) or break
          @callback.( key_data )
        }
      end
    }
  end

  def read_key(socket)
    return socket.readpartial( READSIZE )
    rescue EOFError; disconnected(socket)
  end
  private :read_key

  def disconnected(socket)
    socket_info = Socket.unpack_sockaddr_in(socket.local_address)
    puts "A key client disconnected: #{socket_info}"
    return false
  end

end

