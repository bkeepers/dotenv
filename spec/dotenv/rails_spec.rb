require "spec_helper"
require "rails"
require "dotenv/rails"

# Fake watcher for Spring
class SpecWatcher
  attr_reader :items

  def initialize
    @items = []
  end

  def add(*items)
    @items |= items
  end
end

describe Dotenv::Rails do
  before do
    # Remove the singleton instance if it exists
    Dotenv::Rails.remove_instance_variable(:@instance)

    Rails.env = "test"
    allow(Rails).to receive(:root).and_return Pathname.new(__dir__).join('../fixtures')
    Rails.application = double(:application)
    Spring.watcher = SpecWatcher.new
  end

  after do
    # Reset
    Spring.watcher = nil
    Rails.application = nil
  end

  describe "config.dotenv.files" do
    it "loads files for development environment" do
      Rails.env = "development"

      expect(Dotenv::Rails.config.dotenv.files).to eql(
        [
          Rails.root.join(".env.development.local"),
          Rails.root.join(".env.local"),
          Rails.root.join(".env.development"),
          Rails.root.join(".env")
        ]
      )
    end

    it "does not load .env.local in test rails environment" do
      Rails.env = "test"
      expect(Dotenv::Rails.config.dotenv.files).to eql(
        [
          Rails.root.join(".env.test.local"),
          Rails.root.join(".env.test"),
          Rails.root.join(".env")
        ]
      )
    end
  end

  context "before_configuration" do
    context "with mode = :load" do
      it "calls #load" do
        expect(Dotenv::Rails.instance).to receive(:load)
        ActiveSupport.run_load_hooks(:before_configuration)
      end
    end

    context "with mode = :overload" do
      before { Dotenv::Rails.config.dotenv.mode = :overload }

      it "calls #overload" do
        expect(Dotenv::Rails.instance).to receive(:overload)
        ActiveSupport.run_load_hooks(:before_configuration)
      end
    end
  end

  context "load" do
    before { Dotenv::Rails.load }

    it "watches .env with Spring" do
      expect(Spring.watcher.items).to include(Rails.root.join(".env").to_s)
    end

    it "watches other loaded files with Spring" do
      path = fixture_path("plain.env")
      Dotenv.load(path)
      expect(Spring.watcher.items).to include(path)
    end

    it "loads .env.test before .env" do
      expect(ENV["DOTENV"]).to eql("test")
    end

    it "loads configured files" do
      expect(Dotenv).to receive(:load).with("custom.env")
      Dotenv::Rails.config.dotenv.files = ["custom.env"]
      Dotenv::Rails.load
    end

    context "when Rails.root is nil" do
      before do
        allow(Rails).to receive(:root).and_return(nil)
      end

      it "falls back to RAILS_ROOT" do
        ENV["RAILS_ROOT"] = "/tmp"
        expect(Dotenv::Rails.root.to_s).to eql("/tmp")
      end
    end
  end

  context "overload" do
    before { Dotenv::Rails.overload }

    it "overloads .env with .env.test" do
      expect(ENV["DOTENV"]).to eql("test")
    end

    it "loads configured files" do
      expect(Dotenv).to receive(:overload).with("custom.env")
      Dotenv::Rails.config.dotenv.files = ["custom.env"]
      Dotenv::Rails.overload
    end

    context "when loading a file containing already set variables" do
      subject { Dotenv::Rails.overload }

      it "overrides any existing ENV variables" do
        ENV["DOTENV"] = "predefined"

        expect do
          subject
        end.to(change { ENV["DOTENV"] }.from("predefined").to("test"))
      end
    end
  end
end
