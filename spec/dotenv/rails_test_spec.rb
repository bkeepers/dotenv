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
    ENV["RAILS_ENV"] = "test"
    allow(Rails).to receive(:root)
      .and_return Pathname.new(File.expand_path("../../fixtures", __FILE__))
    allow(Rails).to receive(:env).and_return "test"
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

    it "does not load .env.local in test rails environment" do
      expect(Dotenv::Railtie.instance.send(:dotenv_files)).to eql(
        [
          Rails.root.join(".env.test.local").to_s,
          Rails.root.join(".env.test").to_s,
          Rails.root.join(".env").to_s
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
end
