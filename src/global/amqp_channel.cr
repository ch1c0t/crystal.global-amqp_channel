require "amqp-client"

module Global
  module AMQP
    def self.create_channel(socket_path : String) : ::AMQP::Client::Channel
      client = ::AMQP::Client.new host: socket_path
      conn = client.connect
      ch = conn.channel

      at_exit do
        ch.close
        conn.close
      end

      ch
    end

    module Getters
      def amqp_socket_path : String
        @@amqp_socket_path
      end

      def amqp_channel : ::AMQP::Client::Channel
        @@amqp_channel ||= Global::AMQP.create_channel(Global.amqp_socket_path)
      end
    end
  end

  extend AMQP::Getters

  @@amqp_socket_path : String = begin
    path = ENV["LAVINMQ_AMQP_UNIXSOCKET"]?
    raise "Missing critical environment configuration variable: LAVINMQ_AMQP_UNIXSOCKET" if path.nil?
    path
  end

  @@amqp_channel : ::AMQP::Client::Channel? = nil
end
