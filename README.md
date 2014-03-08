# dotenv [![Build Status](https://secure.travis-ci.org/bkeepers/dotenv.png?branch=master)](https://travis-ci.org/bkeepers/dotenv)

Dotenv loads environment variables from `.env` into `ENV`.

Storing [configuration in the environment](http://www.12factor.net/config) is one of the tenets of a [twelve-factor app](http://www.12factor.net/). Anything that is likely to change between deployment environments–such as resource handles for databases or credentials for external services–should be extracted from the code into environment variables.

But it is not always practical to set environment variables on development machines or continuous integration servers where multiple projects are run. Dotenv load variables from a `.env` file into `ENV` when the environment is bootstrapped.

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

You can also create files per environment, such as `.env.test`.

```shell
S3_BUCKET=tests3bucket
SECRET_KEY=testsecretkey
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

## Environment file generator and example files

You may use the built-in generator rake task along with example and/or environment-default dotenv files. This makes it easy for developers to get started with your project without needing to check your sensitive dotenv files into your project repository.

When you run the generator rake task you will be prompted to enter values for all the provided example keys and default keys, and the target dotenv file will be generated for you.

The default example file is `.env.example`, which should contain all the keys needed to get started with your project. The values for each key in this file may optionally be a description of the key or a default value.

```
# .env.example
AWS_S3_BUCKET=Enter the name of the S3 bucket you'd like to use
AWS_ACCESS_KEY=Enter your Amazon Webservices access key
AWS_SECRET_KEY=Enter your Amazon Webservices secret key
```

Along with the example file, you may also provide a `.env.ENVIRONMENT` file for any environments where you wish to provide default values, to make getting started even easier.

```
# .env.development
AWS_S3_BUCKET=dev-bucket
PORT=3000
```

In this example, the `PORT` key is self explanatory and therefore is not defined in `.env.example` above, so it will be included in the prompts and the generated file, but it will not have a description when the user is prompted. `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` both have descriptions but no default values, while `AWS_S3_BUCKET` has both a description **and** a default value provided.

To generate your `.env.development` you would run `rake dotenv:generate['development']` and enter the values for each key when prompted. 

Of course if `.env.development` is checked into your project with safe defaults, and you're overwriting it by generating a localized `.env.development`, that might be an issue. If you're providing defaults in this way, it is suggested you ignore your local changes to your dotenv file so you don't accidentally commit them.

If you **are** using Rails and do not provide the task with an environment, the current `Rails.env` will be used by default.

If you **are not** using Rails and do not provide the task with an environment argument, the default `.env` file will be loaded and/or created.

### Using the generator in deployments and other workflows

You may use the `Dotenv::Generator` class directly within your deployments or any other workflow where you might need to load or modify dotenv files.

```ruby
require 'dotenv/generator'

# reads examples from .env.example
# reads default values from .env.production if it exists
# writes .env.production
g = Dotenv::Generator.new('production')

# reads examples from .env.descriptions
# reads default values from .env.production if it exists
# writes .env.production
g = Dotenv::Generator.new('production', '.env.descriptions')

# reads examples from .env.example
# reads default values from .env.production if it exists
# reads (and merges) default values from custom.env if it exists
# writes custom.env
g = Dotenv::Generator.new('production', nil, 'custom.env')

# update key/value pairs
g['SOME_KEY'] = 'foobar'
g.set('OTHER_KEY') = 'hello'

# and read their values
puts g['OTHER_KEY']
puts g.get('SOME_KEY')

# trigger the prompts and ask for manual input and update the values
g.prompt

# or ask for just a single value
input_value = g.prompt_for('SOME_KEY')
# this DOES NOT set the value in the values hash, only returns it
# so you might want to update the value manually if you need it
g['SOME_KEY'] = input_value

# you can then write everything to the file
file = g.write
# and maybe push that file up to your production servers

# or you can get the raw string
raw = g.to_s
# so that you can manually dump that into a file on your remote servers
```

## Capistrano integration

If you want to use Dotenv with Capistrano in your production environment, make sure the dotenv gem is included in your Gemfile `:production` group.

### Capistrano version 2.x.x

Add the gem to your `config/deploy.rb` file:

```ruby
require "dotenv/capistrano"
```

It will symlink the `.env` located in `/path/to/shared` in the new release. 


### Capistrano version 3.x.x

Just add `.env` to the list of linked files, for example:

```ruby
set :linked_files, %w{config/database.yml .env}
```

## Should I commit my .env file?

It is recommended that you store development-only settings in your `.env` file, and commit it to your repository. Make sure that all your credentials for your development environment are different from your other deployments. This makes it easy for other developers to get started on your project, without compromising your credentials for other environments.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
