# Changelog

## 0.5.0 - Jan 25, 2013

* Load immediately on require in Rails instead of waiting for initialization
* Add YAML-style variables
    VARIABLE: some value

https://github.com/bkeepers/dotenv/compare/v0.4.0...v0.5.0

## 0.4.0 - Nov 13, 2012

* Add support for quoted options, e.g.:
    VARIABLE='some value'
* Fix rake deprecation warnings

https://github.com/bkeepers/dotenv/compare/v0.3.0...v0.4.0

## 0.3.0 - Oct 25, 2012

* Avoid overriding existing ENV variables so values set before loading the app are maintained.

https://github.com/bkeepers/dotenv/compare/v0.2.0...v0.3.0
