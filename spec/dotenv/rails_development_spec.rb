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
      .and_return Pathname.new(File.expand_path("../../fixtures", __FILE__))
    allow(Rails).to receive(:env).and_return "development"
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

    it "loads .env, .env.#{Rails.env}, .env.local, .env.#{Rails.env}.local" do
      expect(Dotenv::Railtie.instance.send(:dotenv_files)).to eql(
        [
          Rails.root.join(".env.development.local"),
          Rails.root.join(".env.local"),
          Rails.root.join(".env.development"),
          Rails.root.join(".env")
        ]
      )
    end

    it "loads .env.#{Rails.env}.local on top" do
      expect(ENV["DOTENV"]).to eql("development-local")
    end
  end
end
