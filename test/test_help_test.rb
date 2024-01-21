require "active_support/deprecator"
require "active_support/test_case"
require "minitest/autorun"

require "dotenv"
require "dotenv/test_help"

class TestHelpTest < ActiveSupport::TestCase
  test "restores ENV between tests, part 1" do
    assert_nil ENV["DOTENV"], "ENV was not restored between tests"
    ENV["DOTENV"] = "1"
  end

  test "restores ENV between tests, part 2" do
    assert_nil ENV["DOTENV"], "ENV was not restored between tests"
    ENV["DOTENV"] = "2"
  end
end
