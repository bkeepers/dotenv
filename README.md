# dotenv

Loads environment settings for your application from `.env`.

The emerging practice of storing application configuration in  environment variables is a great idea, but it's not always practical to set all of those environment variables in your development or continuous integration environments. [Foreman](https://github.com/ddollar/foreman) provides this handy feature of loading settings from `.env`, which works great for anything that you want to put in your `Procfile`. But it makes things difficult when you want to run a console or rake task. `dotenv` solves that problem.

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
