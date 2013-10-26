require 'optparse'
module Options
  def self.parse!
    options = OpenStruct.new  key_port: 2000,         screen_port: 2001,
                              server_host: 'localhost'

    OptionParser.new do |opts|
      opts.on("-l", "--key_port=val",      Integer) { |arg| options.key_port     = arg }
      opts.on("-d", "--screen_port=val",   Integer) { |arg| options.screen_port  = arg }
      opts.on("-s", "--server_host=val",   String)  { |arg| options.server_host  = arg }
      opts.on("-h", "--help")                       { puts opts; exit }
    end.parse!
    options
  end
end
