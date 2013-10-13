require 'timeout'
require_relative '../lib/screen_server.rb'

describe ScreenServer do
  before do
    server.listen
    client
  end

  let(:server_port) { 2001 }
  let(:server)      { ScreenServer.new(server_port) }
  let(:client)      { Socket.tcp('localhost', server_port) }

  context "Sending Screen Updates" do
    before do
      server.async.write message
    end
    let(:message) { "H" }

    it "should receive the message" do
      Timeout.timeout(3) do
        expect(client.getc).to eq(message)
      end
    end
    # subject { client }
    # its(:getc) { should eq("H") }

  end
end

