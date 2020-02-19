# Ramnagar

A converter from search query to GitHub's Notification query.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ramnagar'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ramnagar

## Usage

It supports only `user:USER_NAME` query. It converts `user:USER_NAME` to `repo:REPO1 repo:REPO2 ...`.

```bash
$ GITHUB_ACCESS_TOKEN=XXXXX ramnagar user:rubocop-hq
repo:rubocop-hq/rubocop-rubycw repo:rubocop-hq/rubocop-rake repo:rubocop-hq/rubocop-extension-generator ....
```

Note that it slices query if the query is over than 1024 characters because of GitHub's limitation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/ramnagar.


## Naming

I found the name with Wikipedia's random article feature.
https://en.wikipedia.org/wiki/Ramnagar,_Nawalparasi
