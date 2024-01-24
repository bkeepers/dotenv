require "spec_helper"
require "active_support/all"
require "rails"
require "dotenv/rails"

describe Dotenv::LogSubscriber do
  let(:logs) { StringIO.new }

  before do
    Dotenv.instrumenter = ActiveSupport::Notifications
    Dotenv::Rails.logger = Logger.new(logs)
  end

  context "set" do
    it "logs when a new instance variable is set" do
      Dotenv.load(fixture_path("plain.env"))
      expect(logs.string).to match(/Set.*PLAIN.*from.*plain.env/)
    end

    it "logs when an instance variable is overwritten" do
      ENV["PLAIN"] = "nope"
      Dotenv.load(fixture_path("plain.env"), overwrite: true)
      expect(logs.string).to match(/Set.*PLAIN.*from.*plain.env/)
    end

    it "does not log when an instance variable is not overwritten" do
      # load everything once and clear the logs
      Dotenv.load(fixture_path("plain.env"))
      logs.truncate(0)

      # load again
      Dotenv.load(fixture_path("plain.env"))
      expect(logs.string).not_to match(/Set.*plain.env/i)
    end

    it "does not log when an instance variable is unchanged" do
      ENV["PLAIN"] = "true"
      Dotenv.load(fixture_path("plain.env"), overwrite: true)
      expect(logs.string).not_to match(/PLAIN/)
    end
  end

  context "save" do
    it "logs when a snapshot is saved" do
      Dotenv.save
      expect(logs.string).to match(/Saved/)
    end
  end

  context "restore" do
    it "logs restored keys" do
      previous_value = ENV["PWD"]
      ENV["PWD"] = "/tmp"
      Dotenv.restore

      expect(logs.string).to match(/Restored.*PWD/)

      # Does not log value
      expect(logs.string).not_to include(previous_value)
    end

    it "logs unset keys" do
      ENV["DOTENV_TEST"] = "LogSubscriber"
      Dotenv.restore
      expect(logs.string).to match(/Unset.*DOTENV_TEST/)
    end

    it "does not log if no keys unset or restored" do
      Dotenv.restore
      expect(logs.string).not_to match(/Restored|Unset/)
    end
  end
end
