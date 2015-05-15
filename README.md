# CCB

CCB - Ruby Wrapper for the Church Community Builder API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ccb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ccb

## Usage

 To use the API you must be an active CCB customer or have access to a demo site
 modify your config/ccb.yml file with the appropriate information.
   username: USERNAME
   password: PASSWORD
   url: https://demochurch.ccbchurch.com/api.php

 The default rails environment is development.

-```ruby
load "./lib/ccb.rb"
person = CCB::Person.find(:all).first
person.full_name #=> "First Last"
person.groups #=> returns an array of associated groups
person2 = CCB::Person.create(:first_name => "Test User", :last_name => "From AP
person2.first_name #=> "Test User"
CCB::Group.search #=> An array of all groups
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/ccb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
