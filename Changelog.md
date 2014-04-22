# Changelog

## 0.11.1 - Apr 22, 2014

* Depend on dotenv-deployment ~>0.0.2, which fixes issues with 0.0.1

## 0.11.0 - Apr 21, 2014

* Extract dotenv-deployment gem. https://github.com/bkeepers/dotenv-deployment

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.10.0...v0.11.0)

## 0.10.0 - Feb 22, 2014

* Add support for executing interpolated commands. (Ruby >= 1.9 only)

        HEAD_SHA=$(git rev-parse HEAD)

* Add `dotenv_role` option in Capistrano.

        set :dotenv_role, [:app, web]

* Add `Dotenv.overload` to overwrite existing environment values.

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.9.0...v0.10.0)

## 0.9.0 - Aug 29, 2013

* Add support for variable expansion.

        HOST="example.com"
        URL="http://${USER}@${HOST}"
        ESCAPED_VARIABLE="this is \$NOT replaced"

* Allow setting variables without a value.

        BLANK=

* Add `dotenv` executable to load `.env` for other scripts.

        $ dotenv ./script.py

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.8.0...v0.9.0)

## 0.8.0 - June 12, 2013

* Added a capistrano recipe to symlink in `.env` on deploy.

* Allow inline comments

        VARIABLE=value # this is a comment

* Raises Dotenv::FormatError when parsing fails

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.7.0...v0.8.0)

## 0.7.0 - April 15, 2013

* Remove deprectated autoloading. Upgrade to 0.6 first and fix any warnings.

* Add Dotenv.load! which raises Errno::ENOENT if the file does not exist

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.6.0...v0.7.0)

## 0.6.0 - Mar 22, 2013

* Add dotenv-rails gem for autoloading in a Rails app

* Deprecated autoloading with plain dotenv gem

* Support for double quotes

        A="some value"
        B="with \"escaped\" quotes"
        C="and newline\n expansion"

* Support for pow-style variables prefixed with export

        export VARIABLE="some value"

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.5.0...v0.6.0)

## 0.5.0 - Jan 25, 2013

* Load immediately on require in Rails instead of waiting for initialization

* Add YAML-style variables

        VARIABLE: some value

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.4.0...v0.5.0)

## 0.4.0 - Nov 13, 2012

* Add support for quoted options, e.g.:

        VARIABLE='some value'

* Fix rake deprecation warnings

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.3.0...v0.4.0)

## 0.3.0 - Oct 25, 2012

* Avoid overriding existing ENV variables so values set before loading the app are maintained.

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.2.0...v0.3.0)
