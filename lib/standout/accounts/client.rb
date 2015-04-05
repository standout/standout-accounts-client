require "standout/accounts/client/version"

require 'cgi'
require 'json'

module Standout
  module Accounts
    module Client
      extend self

      attr_accessor :configuration

      def self.configure
        self.configuration ||= Configuration.new
        yield(configuration)
      end

      # Generate a signature for a given callback uri
      def generate_signature
        digest = OpenSSL::Digest.new('sha256')
        OpenSSL::HMAC.hexdigest(digest, Standout::Accounts::Client.configuration.secret, Standout::Accounts::Client.configuration.callback)
      end

      def confirmation_uri
        sig = generate_signature
        c = Standout::Accounts::Client.configuration
        "#{c.account_server}login/request_token?id=#{c.client_id}&redirect_uri=#{CGI.escape(c.callback)}&signature=#{sig}"
      end

      def login_url
        content = Net::HTTP.get(URI.parse(confirmation_uri))
        json = JSON.parse(content)
        c = Standout::Accounts::Client.configuration
        "#{c.account_server}login/web/#{json['token']}?redirect_uri=#{CGI.escape(c.callback)}"
      end

      class Configuration
        attr_accessor :secret, :client_id, :callback, :account_server

        def initialize
          @account_server = "https://accounts.standout.se/"
        end
      end
    end
  end
end
