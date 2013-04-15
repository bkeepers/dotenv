# Changelog

## 0.7.0 - April 15, 2013

* Remove deprectated autoloading. Upgrade to 0.6 first and fix any warnings.

* Add Dotenv.load! which raises Errno::ENOENT if the file does not exist

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
