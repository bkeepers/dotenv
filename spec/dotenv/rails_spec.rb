require 'spec_helper'
require 'rails'
require 'dotenv/rails'

describe Dotenv::Railtie do
  # Fake watcher for Spring
  class SpecWatcher < Struct.new(:items)
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

  context 'before_configuration' do
    it 'calls #load' do
      expect(Dotenv::Railtie.instance).to receive(:load)
      ActiveSupport.run_load_hooks(:before_configuration)
    end
  end

  context 'load' do
    before { Dotenv::Railtie.load }

    it 'watches .env with Spring' do
      Spring.watcher.include? Rails.root.join('.env')
    end

    it 'loads .env' do
      expect(ENV).to have_key('DOTENV')
    end
  end
end
