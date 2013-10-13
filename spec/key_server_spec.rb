require 'timeout'
require_relative '../lib/key_server.rb'

describe KeyServer do
  before do
    server.listen
  end

  let(:server_port) { 2002 }
  let(:client)      { Socket.tcp('localhost', server_port) }
  let(:callback)    { ->(k){ @global = k } }
  let(:server)      do
    KeyServer.new(server_port, callback)
  end

  context "Sending Screen Updates" do
    let(:message) { "H" }

    it "should receive the message" do
      Timeout.timeout(3) do
        client.write message
        sleep 0.1
        expect(@global).to eq(message)
      end
    end
  end
end
