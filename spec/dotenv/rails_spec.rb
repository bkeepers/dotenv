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

describe Dotenv::Railtie do
  before do
    Rails.env = "test"
    allow(Rails).to receive(:root)
      .and_return Pathname.new(File.expand_path("../../fixtures", __FILE__))
    Rails.application = double(:application)
    Spring.watcher = SpecWatcher.new
  end

  after do
    # Reset
    Spring.watcher = nil
    Rails.application = nil
  end

  context "before_configuration" do
    it "calls #load" do
      expect(Dotenv::Railtie.instance).to receive(:load)
      ActiveSupport.run_load_hooks(:before_configuration)
    end
  end

  context "load" do
    before { Dotenv::Railtie.load }

    it "watches .env with Spring" do
      expect(Spring.watcher.items).to include(Rails.root.join(".env").to_s)
    end

    it "watches other loaded files with Spring" do
      path = fixture_path("plain.env")
      Dotenv.load(path)
      expect(Spring.watcher.items).to include(path)
    end

    it "does not load .env.local in test rails environment" do
      expect(Dotenv::Railtie.instance.send(:dotenv_files)).to eql(
        [
          Rails.root.join(".env.test.local"),
          Rails.root.join(".env.test"),
          Rails.root.join(".env")
        ]
      )
    end

    it "does load .env.local in development environment" do
      Rails.env = "development"
      expect(Dotenv::Railtie.instance.send(:dotenv_files)).to eql(
        [
          Rails.root.join(".env.development.local"),
          Rails.root.join(".env.local"),
          Rails.root.join(".env.development"),
          Rails.root.join(".env")
        ]
      )
    end

    it "loads .env.test before .env" do
      expect(ENV["DOTENV"]).to eql("test")
    end

    context "when Rails.root is nil" do
      before do
        allow(Rails).to receive(:root).and_return(nil)
      end

      it "falls back to RAILS_ROOT" do
        ENV["RAILS_ROOT"] = "/tmp"
        expect(Dotenv::Railtie.root.to_s).to eql("/tmp")
      end
    end
  end

  context "overload" do
    before { Dotenv::Railtie.overload }

    it "does not load .env.local in test rails environment" do
      expect(Dotenv::Railtie.instance.send(:dotenv_files)).to eql(
        [
          Rails.root.join(".env.test.local"),
          Rails.root.join(".env.test"),
          Rails.root.join(".env")
        ]
      )
    end

    it "does load .env.local in development environment" do
      Rails.env = "development"
      expect(Dotenv::Railtie.instance.send(:dotenv_files)).to eql(
        [
          Rails.root.join(".env.development.local"),
          Rails.root.join(".env.local"),
          Rails.root.join(".env.development"),
          Rails.root.join(".env")
        ]
      )
    end

    it "overloads .env with .env.test" do
      expect(ENV["DOTENV"]).to eql("test")
    end

    context "when loading a file containing already set variables" do
      subject { Dotenv::Railtie.overload }

      it "overrides any existing ENV variables" do
        ENV["DOTENV"] = "predefined"

        expect do
          subject
        end.to(change { ENV["DOTENV"] }.from("predefined").to("test"))
      end
    end
  end
end
