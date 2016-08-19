# If want you use dotenv to override variable already set in the system
# then list `dotenv-rails` in the `Gemfile` and require `dotenv/rails-overload`
#
#     gem "dotenv-rails", :require => "dotenv/rails-overload"
#

require "dotenv/rails"
Dotenv::Railtie.overload
