require 'pty'
require 'io/console'

require_relative 'screen_server'
require_relative 'key_server'
require_relative 'vim_interface'
require_relative 'app'

Thread.abort_on_exception = true

class PtyServer
  READSIZE  = 4096
  ENTER_KEY = ?\C-m

  def initialize
    @pty_m, @pty_s  = PTY.open
    @vim_interface  = VimInterface.new @pty_m
    @screen_server  = ScreenServer.new App.options.screen_port
    @key_server     = KeyServer.new App.options.key_port, key_callback
    @pty_s.winsize  = [ App.options.rows, App.options.columns ]
    @application    = App.options.application
  end

  def start
    initialize_pty
    @screen_server.listen
    @key_server.listen
    screen_loop
    spawn_vim
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
        @screen_server.async.write @pty_m.readpartial( READSIZE )
      }
    end
  end

  def spawn_vim
    spawn(@application, in: @pty_s, out: @pty_s)
  end
  private :spawn_vim

  # WTH? -- Let me 'splain:
  # There a difference between the mode that PTY
  # starts the terminal in, and the mode that terminal
  # running the server is in.
  #
  # This means the cursor moves around the screen on the server
  # when you press the arrow keys, but when they are transmitted
  # through the PTY to vim, the escape encoding is different,
  # this results in vim just honking at you and not moving the cursor.
  #
  # By running `tput rmkx` from vim we are setting the PTY to
  # cursor mode, and ta-dah, the arrows work again.
  #
  # We have to go through vim, because there's no instance of the
  # PTY to talk to (PTY has only class methods) and there's no
  # running shell on the PTY to send commands to directly, so
  # we have to use vim's `!` to run `tput`.
  #
  # Reference:
  #  http://homes.mpimf-heidelberg.mpg.de/~rohm/computing/mpimf/notes/terminal.html
  #  http://unix.stackexchange.com/questions/73669/what-are-the-characters-printed-when-altarrow-keys-are-pressed
  #
  # Also, just for fun, in your terminal, pressing "ctrl+v" followed by
  # any key will print the key codes, instead of running them.  Try it
  # with the enter/return key, you'll see that it's equal to `^m`.  Now type
  # a command and instead of hitting `enter`, press "ctrl+m".  Works just the same.
  # That is just too cool.
  #
  def initialize_pty
    # `printf "\033?1h\033=" > #{@pty_s.path}`
    @vim_interface << ENTER_KEY
    @vim_interface << ":!tput rmkx"
    @vim_interface << ENTER_KEY
  end
  private :initialize_pty


  # def save_key key
  #   File.open(@key_file, 'a') { |f| f.putc key }
  # end
  # private :save_key


  # def clear_key_file
  #   File.unlink(@key_file) if File.exists?(@key_file)
  # end
  # private :clear_key_file

end
