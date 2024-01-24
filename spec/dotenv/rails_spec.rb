require "spec_helper"
require "rails"
require "dotenv/rails"

describe Dotenv::Rails do
  let(:application) do
    Class.new(Rails::Application) do
      config.load_defaults Rails::VERSION::STRING.to_f
      config.eager_load = false
      config.logger = ActiveSupport::Logger.new(StringIO.new)
      config.root = fixture_path

      # Remove method fails since app is reloaded for each test
      config.active_support.remove_deprecated_time_with_zone_name = false
    end.instance
  end

  around do |example|
    # These get frozen after the app initializes
    autoload_paths = ActiveSupport::Dependencies.autoload_paths.dup
    autoload_once_paths = ActiveSupport::Dependencies.autoload_once_paths.dup

    # Run in fixtures directory
    Dir.chdir(fixture_path) { example.run }
  ensure
    # Restore autoload paths to unfrozen state
    ActiveSupport::Dependencies.autoload_paths = autoload_paths
    ActiveSupport::Dependencies.autoload_once_paths = autoload_once_paths
  end

  before do
    Rails.env = "test"
    Rails.application = nil
    Spring.watcher = Set.new # Responds to #add

    begin
      # Remove the singleton instance if it exists
      Dotenv::Rails.remove_instance_variable(:@instance)
    rescue
      nil
    end
  end

  describe "files" do
    it "loads files for development environment" do
      Rails.env = "development"

      expect(Dotenv::Rails.files).to eql(
        [
          application.root.join(".env.development.local"),
          application.root.join(".env.local"),
          application.root.join(".env.development"),
          application.root.join(".env")
        ]
      )
    end

    it "does not load .env.local in test rails environment" do
      Rails.env = "test"
      expect(Dotenv::Rails.files).to eql(
        [
          application.root.join(".env.test.local"),
          application.root.join(".env.test"),
          application.root.join(".env")
        ]
      )
    end
  end

  it "watches other loaded files with Spring" do
    application.initialize!
    path = fixture_path("plain.env")
    Dotenv.load(path)
    expect(Spring.watcher).to include(path.to_s)
  end

  context "before_configuration" do
    it "calls #load" do
      expect(Dotenv::Rails.instance).to receive(:load)
      ActiveSupport.run_load_hooks(:before_configuration)
    end
  end

  context "load" do
    subject { application.initialize! }

    it "watches .env with Spring" do
      subject
      expect(Spring.watcher).to include(fixture_path(".env").to_s)
    end

    it "loads .env.test before .env" do
      subject
      expect(ENV["DOTENV"]).to eql("test")
    end

    it "loads configured files" do
      Dotenv::Rails.files = [fixture_path("plain.env")]
      expect { subject }.to change { ENV["PLAIN"] }.from(nil).to("true")
    end

    context "with overwrite = true" do
      before { Dotenv::Rails.overwrite = true }

      it "overwrites .env with .env.test" do
        subject
        expect(ENV["DOTENV"]).to eql("test")
      end

      it "overwrites any existing ENV variables" do
        ENV["DOTENV"] = "predefined"
        expect { subject }.to(change { ENV["DOTENV"] }.from("predefined").to("test"))
      end
    end
  end

  describe "root" do
    it "returns Rails.root" do
      expect(Dotenv::Rails.root).to eql(Rails.root)
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

  describe "autorestore" do
    it "is loaded if RAILS_ENV=test" do
      expect(Dotenv::Rails.autorestore).to eq(true)
      expect(Dotenv::Rails.instance).to receive(:require).with("dotenv/autorestore")
      application.initialize!
    end

    it "is not loaded if RAILS_ENV=development" do
      Rails.env = "development"
      expect(Dotenv::Rails.autorestore).to eq(false)
      expect(Dotenv::Rails.instance).not_to receive(:require).with("dotenv/autorestore")
      application.initialize!
    end

    it "is not loaded if autorestore set to false" do
      Dotenv::Rails.autorestore = false
      expect(Dotenv::Rails.instance).not_to receive(:require).with("dotenv/autorestore")
      application.initialize!
    end
  end
end
