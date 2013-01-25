# Changelog

## 0.5.0 - Jan 25, 2013

* Load immediately on require in Rails instead of waiting for initialization
* Add YAML-style variables
    VARIABLE: some value

## 0.4.0 - Nov 13, 2012

* Add support for quoted options, e.g.:
    VARIABLE='some value'
* Fix rake deprecation warnings

## 0.3.0 - Oct 25, 2012

* Avoid overriding existing ENV variables so values set before loading the app are maintained.
