require 'optparse'
module Options
  def self.parse!
    # default_key_file = File.join(__dir__, '../', 'tmp/keys')
    default_rows = `tput lines`.to_i
    default_cols = `tput cols`.to_i
    options = OpenStruct.new  key_port: 2000,     screen_port: 2001,
                                  rows: default_rows, columns: default_cols

    OptionParser.new do |opts|
      opts.banner =<<HEREDOC
dev/pty/server: Quickly share any terminal application with remote users
Usage:    dev-pty-server <application name and arguments> [opts]
Example:  dev-pty-server "vim"

Defaults:
  #{options.to_h.map{|k,v| "#{k} = #{v}"}.join("\n  ")}

HEREDOC

      opts.on("-k", "--key_port=val",     Integer) { |arg| options.key_port    = arg }
      opts.on("-s", "--screen_port=val",  Integer) { |arg| options.screen_port = arg }
      opts.on("-r", "--rows=val",         Integer) { |arg| options.rows        = arg }
      opts.on("-c", "--columns=val",      Integer) { |arg| options.columns     = arg }
      opts.on("-h", "--help")                      { puts opts; exit }
    end.parse!
    options.application = ARGV[0] or abort( "An application name is required." )
    options
  end
end
