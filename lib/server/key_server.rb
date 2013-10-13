require 'socket'
require 'celluloid'
Thread.abort_on_exception = true

class KeyServer
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
          @callback[ socket.getc ]
        }
      end
    }
  end

end
