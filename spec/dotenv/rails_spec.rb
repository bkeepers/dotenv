require 'spec_helper'
require 'rails'
require 'dotenv/rails'

describe Dotenv::Railtie do
  # Fake watcher for Spring
  class SpecWatcher
    attr_reader :items

    def initialize
      @items = Set.new
    end

    def add(*items)
      @items.merge items
    end
  end

  before do
    allow(Rails).to receive(:root).and_return Pathname.new(File.expand_path('../../../', __FILE__))
    allow(Spring).to receive(:application_root_path).and_return(Rails.root)
    Spring.watcher = SpecWatcher.new
  end

  after do
    # Reset
    Dotenv.instrumenter = nil
    ActiveSupport::Notifications.notifier = ActiveSupport::Notifications::Fanout.new
    Spring.watcher = nil
  end

  context 'before_configuration' do
    it 'calls #load' do
      expect(Dotenv::Railtie.instance).to receive(:load)
      ActiveSupport.run_load_hooks(:before_configuration)
    end
  end

  context 'load' do
    before { Dotenv::Railtie.load }

    it 'watches .env with Spring' do
      expect(Spring.watcher.items).to include(Rails.root.join('.env').to_s)
    end

    it 'watches other loaded files with Spring' do
      path = fixture_path('plain.env')
      Dotenv.load(path)
      expect(Spring.watcher.items).to include(path)
    end

    it 'loads .env' do
      expect(ENV).to have_key('DOTENV')
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
