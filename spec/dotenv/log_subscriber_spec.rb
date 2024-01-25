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

  describe "load" do
    it "logs when a file is loaded" do
      Dotenv.load(fixture_path("plain.env"))
      expect(logs.string).to match(/Loaded.*plain.env/)
      expect(logs.string).to match(/Set.*PLAIN/)
    end
  end

  context "update" do
    it "logs when a new instance variable is set" do
      Dotenv.update({"PLAIN" => "true"})
      expect(logs.string).to match(/Set.*PLAIN/)
    end

    it "logs when an instance variable is overwritten" do
      ENV["PLAIN"] = "nope"
      Dotenv.update({"PLAIN" => "true"}, overwrite: true)
      expect(logs.string).to match(/Set.*PLAIN/)
    end

    it "does not log when an instance variable is not overwritten" do
      ENV["FOO"] = "existing"
      Dotenv.update({"FOO" => "new"})
      expect(logs.string).not_to match(/FOO/)
    end

    it "does not log when an instance variable is unchanged" do
      ENV["PLAIN"] = "true"
      Dotenv.update({"PLAIN" => "true"}, overwrite: true)
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
