require "./spec_helper"

describe Global do
  it "works" do
    Global.amqp_channel.class.should eq ::AMQP::Client::Channel
  end
end
