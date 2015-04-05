# Standout Accounts Client

This is a Ruby Gem for simplifying authentication to the Standout Accounts service.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'standout-accounts-client', git: 'git://github.com/standout/standout-accounts-client.git'
```

And then execute:

    $ bundle install


## Usage

Create a [Standout Account](https://accounts.standout.se/) and [create a new client](https://accounts.standout.se/clients). You will get a client id and a client secret. You need both in the configuration.
This is usually put in an initializer.

```
client = Standout::Accounts::Client

client.configure do |c|
  c.client_id = '123'
  c.secret = 'yoUrSecreTcoDE231'
  c.callback = 'https://example.com/sessions/create'
end

```

The `callback` settings is where the user will be redirected after authenticating (successfully or not).
If they are successfully authenticated it will come back with a token parameter set.
Given the callback above it will be `https://example.com/sessions/create?token=abc123`.

To authenticate a user, first send them to the accounts server. If you are using Ruby on Rails it will
look something like this.

```
class SessionController < ApplicationController::Base
  def new
    redirect_to Standout::Accounts::Client.login_url
  end

  def create
    if params[:token]
      @user = User.where(email: params[:email]).first_or_initialize
      @user.token = params[:token]
      session[:user_id] = @user.id
      redirect_to root_url, notice: 'Welcome, you are now logged in!'
    else
      render text: 'Authorization failed'
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/standout-accounts-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
