# Changelog

[Unreleased changes](https://github.com/bkeepers/dotenv/compare/v2.7.5...master)

## 2.7.5 - July 31st, 2019

* Fix for \s after separator [#399](https://github.com/bkeepers/dotenv/pull/399)
* README formatting updates [#398](https://github.com/bkeepers/dotenv/pull/398)

## 2.7.4 - June 23rd, 2019

* Fix `NoMethodError` in non-Rails environments [#394](https://github.com/bkeepers/dotenv/pull/394)

## 2.7.3 - June 22nd, 2019

* Fix for parallel spec tasks initializing in development [#384](https://github.com/bkeepers/dotenv/pull/384)
* Test against updated rubies [#383](https://github.com/bkeepers/dotenv/pull/383), [#387](https://github.com/bkeepers/dotenv/pull/387)
* Conditional branch cleanup for clarity of intent [#385](https://github.com/bkeepers/dotenv/pull/385)
* Fix for load order issue with Railties [#391](https://github.com/bkeepers/dotenv/pull/391)
* NEW: dotenv-templates using the -t flag [#377](https://github.com/bkeepers/dotenv/pull/377), [#393](https://github.com/bkeepers/dotenv/pull/393)


## 2.7.2 - March 25th, 2019

* Cleaned up CLI while resolving regressions in 2.7.1 [#382](https://github.com/bkeepers/dotenv/pull/382)

## 2.7.1 - February 24, 2019

* Fixes regression with CLI experience ([#376](https://github.com/bkeepers/dotenv/pull/376))

## 2.7.0 - February 21, 2019

* Add Dotenv.parse method ([#362](https://github.com/bkeepers/dotenv/pull/362))
* Add Support for Rails 6.0 ([#370](https://github.com/bkeepers/dotenv/pull/370))
* Improve dotenv CLI output ([#374](https://github.com/bkeepers/dotenv/pull/374))
* Add GitHub Actions automation ([#369](https://github.com/bkeepers/dotenv/pull/369))
* Test against Ruby 2.6 ([#372](https://github.com/bkeepers/dotenv/pull/372))

## 2.6.0 - January 5, 2019

* Added require keys method to raise if not defined ([#354](https://github.com/bkeepers/dotenv/pull/354))
* Use latest Ruby version on CI ([#356](https://github.com/bkeepers/dotenv/pull/356), [#363](https://github.com/bkeepers/dotenv/pull/363))
* Clarify variable hierarchy in README.md ([#358](https://github.com/bkeepers/dotenv/pull/358))
* Use SVG Travis CI badge ([#360](https://github.com/bkeepers/dotenv/pull/360))

## 2.5.0 - June 21, 2018

This release re-introduces [multiline values](https://github.com/bkeepers/dotenv/pull/346) with proper protections against the regressions that were reported in 2.3.0, and corrects a [breaking change](https://github.com/bkeepers/dotenv/pull/345) in the API from 2.4 for `Dotenv::Environment`.

## 2.4.0 - Apr 23, 2018

This release reverts `Parse multiline values` ([#318](https://github.com/bkeepers/dotenv/pull/318), [#329](https://github.com/bkeepers/dotenv/pull/329)) due to a parsing regression that was discovered after the last release ([#336](https://github.com/bkeepers/dotenv/issues/336), [#339](https://github.com/bkeepers/dotenv/issues/339), [#341](https://github.com/bkeepers/dotenv/issues/341)).

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.3.0...v2.4.0)

## 2.3.0 - Apr 19, 2018

* Skip over lines that don't set an envvars ([#291](https://github.com/bkeepers/dotenv/pull/291))
* Document the -f flag ([#310](https://github.com/bkeepers/dotenv/pull/310))
* Existing variable takes precendence when performing substitution ([#313](https://github.com/bkeepers/dotenv/pull/313))
* Parse multiline values ([#318](https://github.com/bkeepers/dotenv/pull/318), [#329](https://github.com/bkeepers/dotenv/pull/329))
* Fix load to respect existing environment variables over env file when doing variable interpolation ([#323](https://github.com/bkeepers/dotenv/pull/323))
* Add gem version badge to README.md ([#328](https://github.com/bkeepers/dotenv/pull/328))
* Rescue from bundler require error ([#330](https://github.com/bkeepers/dotenv/pull/330))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.2.2...v2.3.0)

## 2.2.2 - Apr 9, 2018

* Support Rails 5.2 ([#325](https://github.com/bkeepers/dotenv/pull/325))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.2.1...v2.2.2)

## 2.2.1 - Apr 28, 2017

* Support Rails 5.1 ([#299](https://github.com/bkeepers/dotenv/pull/299))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.2.0...v2.2.1)

## 2.2.0 - Jan 27, 2017

* Drop official support for Ruby 1.9, jruby, and Rubinius. They may continue to work, but tests are not run against them. ([#283](https://github.com/bkeepers/dotenv/pull/283))
* Allow leading and trailing whitespace ([#276](https://github.com/bkeepers/dotenv/pull/276), [#277](https://github.com/bkeepers/dotenv/pull/277))
* [dotenv-rails] Fix for rspec rake tasks initializing in development ([#241](https://github.com/bkeepers/dotenv/pull/241))
* [dotenv-rails] Allow a local file per environment, e.g. `.env.development.local` ([#281](https://github.com/bkeepers/dotenv/pull/281))
* [dotenv-rails] No longer load `.env.local` in rails' test environment ([#280](https://github.com/bkeepers/dotenv/pull/280))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.1.2...v2.2.0)

## 2.1.2 - Jan 16, 2017

* Fix parser to allow leading whitespace before variables ([#276](https://github.com/bkeepers/dotenv/pull/276))
* [dotenv-rails] Fix bug with `require "dotenv/rails-now"` in older versions of rails ([#269](https://github.com/bkeepers/dotenv/pull/269))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.1.1...v2.1.2)

## 2.1.1 - Mar 28, 2016

* Fix load error when using Spring w/ custom config ([#246](https://github.com/bkeepers/dotenv/pull/246))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.1.0...v2.1.1)

## 2.1.0 - Jan 13, 2016

* Relax dependency on `railties` to allow Rails 5.0 apps. ([#226](https://github.com/bkeepers/dotenv/pull/226))
* Fix scenario where some escaped `$` would not be unescaped. ([#222](https://github.com/bkeepers/dotenv/pull/222))
* Gracefully handle files with UTF-8 BOM ([#225](https://github.com/bkeepers/dotenv/pull/225))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.0.2...v2.1.0)

## 2.0.2 - June 19, 2015

* Support carriage returns in addition to newlines in .env ([#194](https://github.com/bkeepers/dotenv/pull/194))
* Add runtime dependency on rails 4 for dotenv-rails ([#189](https://github.com/bkeepers/dotenv/pull/189))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.0.1...v2.0.2)

## 2.0.1 - Apr 3, 2015

* Fix for expansion of escaped variables ([#181](https://github.com/bkeepers/dotenv/pull/181))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v2.0.0...v2.0.1)

## 2.0.0 - Mar 5, 2015

* `.env.local` and `.env.#{Rails.env}` will be automatically be loaded with the `dotenv-rails` gem.

* Drop official support for Ruby 1.8.7 and REE. They may still continue to work, but will not be tested against. Lock to version "<= 1.1" if you are using Ruby 1.8.

* `dotenv-rails` now only supports Rails 4. Manually configure dotenv if you are using Rails 3.

* Support -f option to dotenv executable

        dotenv -f /path/to/.env,/path/to/another/.env

* Fix issue calling `Dotenv::Railtie.load` in Rails 4.1 before application is defined (#155)

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v1.0.2...v2.0.0)

## 1.0.2 - Oct 14, 2014

* Define `#load` on `Dotenv::Railtie`, which can be called to manually load `dotenv` before Rails has initialized.

* add `dotenv/rails-now`, which can be required in the `Gemfile` to immediately load dotenv.

        gem 'dotenv-rails', require: 'dotenv/rails-now'
        gem 'gem-that-requires-env-variables'

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v1.0.1...v1.0.2)

## 1.0.1 - Oct 4, 2014

* Fix load error with Spring when running `rails server` ([#140](https://github.com/bkeepers/dotenv/issues/140))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v1.0.0...v1.0.1)

## 1.0.0 - Oct 3, 2014

* dotenv-rails is now loaded during the `before_configuration` callback, which is fired when the `Application` constant is defined (`class Application < Rails::Application`).

* Remove deprecated features. Upgrade to 0.11.0 and fix deprecation warnings before upgrading to 1.0.0.

* Watch .env for changes with Spring in Rails 4 ([#118](https://github.com/bkeepers/dotenv/pull/118))

* Fix deprecation warnings for `File.exists?` ([#121](https://github.com/bkeepers/dotenv/pull/121/))

* Use `Rails.root` to find `.env` ([#122](https://github.com/bkeepers/dotenv/pull/122/files))

* Avoid substitutions inside single quotes ([#124](https://github.com/bkeepers/dotenv/pull/124))

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.11.1...v1.0.0)

## 0.11.1 - Apr 22, 2014

* Depend on dotenv-deployment ~>0.0.2, which fixes issues with 0.0.1

[Full Changelog](https://github.com/bkeepers/dotenv/compare/v0.11.0...v0.11.1)

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
