require 'pty'
require 'io/console'

require_relative 'screen_server'
require_relative 'key_server'
require_relative 'vim_interface'
require_relative 'app'

Thread.abort_on_exception = true

class PtyServer
  def initialize
    @pty_m, @pty_s  = PTY.open
    @vim_interface  = VimInterface.new @pty_m
    @screen_server  = ScreenServer.new App.options.screen_port
    @key_server     = KeyServer.new App.options.key_port, key_callback
    @pty_s.winsize  = [ 35, 100 ]
  end

  def start
    spawn_vim
    @screen_server.listen
    @key_server.listen
    screen_loop
  end

  def key_callback
    ->(key){
      print key
      @vim_interface << key
    }
  end

  def screen_loop
    Thread.new do
      loop {
        @screen_server.async.write @pty_m.read( 1 )
      }
    end
  end

  def spawn_vim
    spawn("vim", in: @pty_s, out: @pty_s)
    sleep 0.2 # give it a moment to boot
  end
  private :spawn_vim

  # def save_key key
  #   File.open(@key_file, 'a') { |f| f.putc key }
  # end
  # private :save_key


  # def clear_key_file
  #   File.unlink(@key_file) if File.exists?(@key_file)
  # end
  # private :clear_key_file

end
