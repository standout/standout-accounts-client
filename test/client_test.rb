require 'minitest_helper'

describe Standout::Accounts::Client do

  def client
    Standout::Accounts::Client
  end

  before do
    client.configure do |config|
      config.secret = "pqzR01Hj5Wt3SqHGtGvFlOnTM0x0LjKzjLVAvMcvyis"
      config.client_id = "123"
      config.callback = "http://example.com/sessions/callback"
    end
  end

  it 'has a version number' do
    refute_nil client::VERSION
  end

  it 'has a default account server' do
    client.configuration.account_server.must_equal 'https://accounts.standout.se/'
  end

  it 'can save the configuration' do
    assert_equal "pqzR01Hj5Wt3SqHGtGvFlOnTM0x0LjKzjLVAvMcvyis", client.configuration.secret
    assert_equal "123", client.configuration.client_id
    assert_equal "http://example.com/sessions/callback", client.configuration.callback
  end

  it 'generates a correct signature' do
    client.generate_signature.must_equal '2e183d136130530268a5b109947f29d49959b67eeec6aa7291415fb0d4b94b19'
  end

  it 'generates a login url' do

    stub_request(:get, "https://accounts.standout.se/login/request_token?id=123&redirect_uri=http://example.com/sessions/callback&signature=2e183d136130530268a5b109947f29d49959b67eeec6aa7291415fb0d4b94b19").
    to_return(:body => '{ "token": "abc123" }', :status => 200)

    client.login_url.must_equal 'https://accounts.standout.se/login/web/abc123?redirect_uri=http%3A%2F%2Fexample.com%2Fsessions%2Fcallback'
  end

end
