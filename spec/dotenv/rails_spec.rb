require "spec_helper"
require "rails"
require "dotenv/rails"

describe Dotenv::Rails do
  let(:log_output) { StringIO.new }
  let(:application) do
    log_output = self.log_output
    Class.new(Rails::Application) do
      config.load_defaults Rails::VERSION::STRING.to_f
      config.eager_load = false
      config.logger = ActiveSupport::Logger.new(log_output)
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
    Rails.logger = nil

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
          ".env.development.local",
          ".env.local",
          ".env.development",
          ".env"
        ]
      )
    end

    it "does not load .env.local in test rails environment" do
      Rails.env = "test"
      expect(Dotenv::Rails.files).to eql(
        [
          ".env.test.local",
          ".env.test",
          ".env"
        ]
      )
    end

    it "can be modified in place" do
      Dotenv::Rails.files << ".env.shared"
      expect(Dotenv::Rails.files.last).to eq(".env.shared")
    end
  end

  it "watches other loaded files with Spring" do
    stub_spring
    application.initialize!
    path = fixture_path("plain.env")
    Dotenv.load(path)
    expect(Spring.watcher).to include(path.to_s)
  end

  it "doesn't raise an error if Spring.watch is not defined" do
    stub_spring(load_watcher: false)

    expect {
      application.initialize!
    }.to_not raise_error
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
      stub_spring
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

    it "loads file relative to Rails.root" do
      allow(Rails).to receive(:root).and_return(Pathname.new("/tmp"))
      Dotenv::Rails.files = [".env"]
      expect(Dotenv).to receive(:load).with("/tmp/.env", {overwrite: false})
      subject
    end

    it "returns absolute paths unchanged" do
      Dotenv::Rails.files = ["/tmp/.env"]
      expect(Dotenv).to receive(:load).with("/tmp/.env", {overwrite: false})
      subject
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

    it "is not loaded if ClimateControl is defined" do
      stub_const("ClimateControl", Module.new)
      expect(Dotenv::Rails.instance).not_to receive(:require).with("dotenv/autorestore")
      application.initialize!
    end

    it "is not loaded if IceAge is defined" do
      stub_const("IceAge", Module.new)
      expect(Dotenv::Rails.instance).not_to receive(:require).with("dotenv/autorestore")
      application.initialize!
    end
  end

  describe "logger" do
    it "replays to Rails.logger" do
      expect(Dotenv::Rails.logger).to be_a(Dotenv::ReplayLogger)
      Dotenv::Rails.logger.debug("test")

      application.initialize!

      expect(Dotenv::Rails.logger).not_to be_a(Dotenv::ReplayLogger)
      expect(log_output.string).to include("[dotenv] test")
    end

    it "does not replace custom logger" do
      logger = Logger.new(log_output)

      Dotenv::Rails.logger = logger
      application.initialize!
      expect(Dotenv::Rails.logger).to be(logger)
    end
  end

  def stub_spring(load_watcher: true)
    spring = Module.new

    if load_watcher
      def spring.watcher
        @watcher ||= Set.new
      end

      def spring.watch(path)
        watcher.add path
      end
    end

    stub_const "Spring", spring
  end
end
