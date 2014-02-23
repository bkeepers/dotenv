# dotenv [![Build Status](https://secure.travis-ci.org/bkeepers/dotenv.png?branch=master)](https://travis-ci.org/bkeepers/dotenv)

Shim to load environment variables from `.env` into `ENV` in *development*.

Storing [configuration in the environment](http://www.12factor.net/config) is one of the tenets of a [twelve-factor app](http://www.12factor.net/). Anything that is likely to change between deployment environments–such as resource handles for databases or credentials for external services–should be extracted from the code into environment variables.

But it is not always practical to set environment variables on development machines or continuous integration servers where multiple projects are run. dotenv loads variables from a `.env` file into `ENV` when the environment is bootstrapped.

dotenv is intended to be used in development. If you would like to use it in production or other environments, see [dotenv-deployment](https://github.com/bkeepers/dotenv-deployment)


## Installation

### Rails

Add this line to the top of your application's Gemfile:

```ruby
gem 'dotenv-rails', :groups => [:development, :test]
```

And then execute:

```shell
$ bundle
```

It should be listed in the Gemfile before any other gems that use environment variables, otherwise those gems will get initialized with the wrong values.

### Sinatra or Plain ol' Ruby

Install the gem:

```shell
$ gem install dotenv
```

As early as possible in your application bootstrap process, load `.env`:

```ruby
require 'dotenv'
Dotenv.load
```

Alternatively, you can use the `dotenv` executable to launch your application:

```shell
$ dotenv ./script.py
```

To ensure `.env` is loaded in rake, load the tasks:

```ruby
require 'dotenv/tasks'

task :mytask => :dotenv do
    # things that require .env
end
```

## Usage

Add your application configuration to your `.env` file in the root of your project:

```shell
S3_BUCKET=YOURS3BUCKET
SECRET_KEY=YOURSECRETKEYGOESHERE
```

An alternate yaml-like syntax is supported:

```yaml
S3_BUCKET: yamlstyleforyours3bucket
SECRET_KEY: thisisalsoanokaysecret
```

Whenever your application loads, these variables will be available in `ENV`:

```ruby
config.fog_directory  = ENV['S3_BUCKET']
```

## Should I commit my .env file?

It is recommended that you store development-only settings in your `.env` file, and commit it to your repository. Make sure that all your credentials for your development environment are different from your other deployments. This makes it easy for other developers to get started on your project, without compromising your credentials for other environments.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
