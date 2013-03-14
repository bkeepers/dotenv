# dotenv [![Build Status](https://secure.travis-ci.org/bkeepers/dotenv.png)](https://travis-ci.org/bkeepers/dotenv)

Loads environment variables from `.env` into `ENV`, automagically.

Read more about the [motivation for dotenv at opensoul.org](http://opensoul.org/blog/archives/2012/07/24/dotenv/).

## Installation

### Rails

Add this line to your application's Gemfile:

```ruby
gem 'dotenv-rails', :groups => [:development, :test]
```

And then execute:

    $ bundle

### Sinatra or Plain ol' Ruby

Install the gem:

    $ gem install dotenv

As early as possible in your application bootstrap process, load `.env`:

```ruby
require 'dotenv'
Dotenv.load
```

To ensure `.env` is loaded in rake, load the tasks:

```ruby
require 'dotenv/tasks'

task :mytask => :dotenv do
    # things that require .env
end
```

## Usage

Add your application configuration to `.env`.

```shell
S3_BUCKET=dotenv
SECRET_KEY=sssshhh!
```

You can also create files per environment, such as `.env.test`:

```shell
S3_BUCKET=test
SECRET_KEY=test
```

An alternate yaml-like syntax is supported:

```yaml
S3_BUCKET: dotenv
SECRET_KEY: 'sesame, open'
```

Whenever your application loads, these variables will be available in `ENV`:

```ruby
config.fog_directory  = ENV['S3_BUCKET']
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
