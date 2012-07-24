# dotenv

Loads environment variables from `.env` into `ENV`, automagically.

Read more about the [motivation for dotenv at opensoul.org](http://opensoul.org/blog/archives/2012/07/24/dotenv/).

## Installation

### Rails

Add this line to your application's Gemfile:

    gem 'dotenv', :groups => [:development, :test]

And then execute:

    $ bundle

### Sinatra or Plain ol' Ruby

Install the gem:

    $ gem install dotenv

As early as possible in your application bootstrap process, load `.env`:

    Dotenv.load

To ensure `.env` is loaded in rake, load the tasks:

    require 'dotenv/tasks'

    task :mytask => :dotenv do
      # things that require .env
    end

## Usage

Add your application configuration to `.env`.

    S3_BUCKET=dotenv
    SECRET_KEY=sssshhh!

Whenever your application loads, these variables will be available in `ENV`:

    config.fog_directory  = ENV['S3_BUCKET']

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
