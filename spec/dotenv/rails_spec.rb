require "spec_helper"
require "rails"
require "dotenv/rails"

describe Dotenv::Rails do
  before do
    # Remove the singleton instance if it exists
    Dotenv::Rails.remove_instance_variable(:@instance) rescue nil

    Rails.env = "test"
    allow(Rails).to receive(:root).and_return Pathname.new(__dir__).join("../fixtures")
    Rails.application = double(:application)
    Spring.watcher = Set.new # Responds to #add
  end

  after do
    # Reset
    Spring.watcher = nil
    Rails.application = nil
  end

  describe "files" do
    it "loads files for development environment" do
      Rails.env = "development"

      expect(Dotenv::Rails.files).to eql(
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
      expect(Dotenv::Rails.files).to eql(
        [
          Rails.root.join(".env.test.local"),
          Rails.root.join(".env.test"),
          Rails.root.join(".env")
        ]
      )
    end
  end

  it "watches loaded files with Spring" do
    path = fixture_path("plain.env")
    Dotenv.load(path)
    expect(Spring.watcher).to include(path.to_s)
  end

  context "before_configuration" do
    it "calls #load" do
      expect(Dotenv::Rails).to receive(:load)
      ActiveSupport.run_load_hooks(:before_configuration, )
    end
  end

  context "load" do
    subject { Dotenv::Rails.load }

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

      it "overrides any existing ENV variables" do
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
end
