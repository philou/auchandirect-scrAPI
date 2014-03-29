# Auchandirect::ScrAPI

A ruby gem providing, through scrapping, an API to the french www.auchandirect.fr online grocery

## Installation

Add this line to your application's Gemfile:

    gem 'auchandirect-scrAPI'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install auchandirect-scrAPI

## Status

This library should be production ready.
* It is automaticaly tested through [Travis](https://travis-ci.org/philou/auchandirect-scrAPI)
* It should be daily tested through [TravisCron](http://traviscron.pythonanywhere.com/) to quickly detect modification at www.auchandirect.fr

## Usage

This API has 2 main features :
* walking the store to collect all the different items in the different subsections
* Connecting with a user account in order to fill his cart

It is not currently possible to pay and validate an order through this API. In order to do so, a user must :

1. first disconnect from the API
2. only then reconnect with his account through a browser, and order his pre-filled cart

### Sample usage

Suppose you'd want to fill your cart with all the pizzas available on the store, this is how you would do it :

```ruby
cart = Auchandirect::ScrAPI::Cart.login('buyer@mail.org', 'password')

begin

  Storexplore::Api.browse('http://www.auchandirect.fr').categories.each do |cat|
    cat.categories.each do |s_cat|
      s_cat.categories.each do |ss_cat|
        ss_cat.items.each do |item|

          if item.attributes[:name] =~ /pizza/i

            cart.add_to_cart(item.attributes[:remote_id])

          end
        end
      end
    end
  end

ensure

  ensure cart.logout

end

```

### Client side usage

In order to make it possible for a web browser to automaticaly connect to auchandirect.fr (for example in an iframe, to pay for a cart that was previously filled with this gem on the server), the Auchandirect::ScrAPI::Cart class exposes enough information to generate the html that makes this possible. You can have a look at spec/lib/auchandirect/scrAPI/client_cart_shared_examples.rb for more details. *This whole thing remains tricky and subject to failures though.*

### Mocking

In order to run quicker and offline tests for the rest of your app, you can use Auchandirect::ScrAPI::DummyCart in place of a real cart. This cart is compatible with Storexplore's dummy store generators (see https://github.com/philou/storexplore).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Running the tests

* If you want to run the tests, you'll need valid auchandirect credentials. So first, head up to www.auchandirect.fr and create yourself an account if you don't yet have one.
* To run guard or rspec, you'll have to specify these credentials through environment variables :

```shell
AUCHANDIRECT_TEST_EMAIL=me@mail.com AUCHANDIRECT_TEST_PASSWORD=secret bundle exec rspec spec
```

* If you get tired of repeating this, you can create yourself a 'credentials' shell script at the root of the repo :

```bash
#!/bin/sh
AUCHANDIRECT_TEST_EMAIL=me@mail.com AUCHANDIRECT_TEST_PASSWORD=secret "$@"```
```

* Make it exectuable ```chmod +x credentials```
* You can now simply run any command with your credentials

```shell
./credentials bundle exec rspec spec
```