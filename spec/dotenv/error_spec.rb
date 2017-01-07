require "spec_helper"
ENV["RAILS_ENV"] = "test"
require "rails"

describe Dotenv::MissingKeys do
  context "missing key" do
    it "throws standard error" do
      expect { MissingKeys.new("MISSING_KEY") }.to raise_error(StandardError)
    end
  end
end
