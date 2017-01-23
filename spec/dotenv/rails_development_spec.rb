require "spec_helper"
require "rails"
require "dotenv/rails"

describe Dotenv::Railtie do
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

  before do
    ENV["RAILS_ENV"] = "development"
    allow(Rails).to receive(:root)
      .and_return Pathname.new(File.expand_path("../fixtures", __dir__))
    Rails.application = double(:application)
    Spring.watcher = SpecWatcher.new
  end

  after do
    # Reset
    Spring.watcher = nil
    Rails.application = nil
    ENV.delete "RAILS_ENV"
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

    it "loads .env, .env.local, and .env.#{Rails.env}" do
      p Rails.root
      expect(Spring.watcher.items).to eql(
        [
          Rails.root.join(".env.local").to_s,
          Rails.root.join(".env.development").to_s,
          Rails.root.join(".env").to_s
        ]
      )
    end

    it "loads .env.local before .env" do
      expect(ENV["DOTENV"]).to eql("local")
    end
  end
end
