require 'optparse'
module Options
  def self.parse!
    # default_key_file = File.join(__dir__, '../', 'tmp/keys')
    options = OpenStruct.new  key_port: 2000, screen_port: 2001

    OptionParser.new do |opts|
      opts.on("-k", "--key_port=val",          Integer) { |arg| options.key_port          = arg }
      opts.on("-s", "--screen_port=val",       Integer) { |arg| options.screen_port       = arg }
      opts.on("-h", "--help")                           { exec "more #{__FILE__}"               }
    end.parse!
    options
  end
end
