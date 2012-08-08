require 'spec_helper'

describe Dotenv::Environment do
  let(:env_path) { fixture_path('plain.env') }
  let(:dotenv)   { Dotenv::Environment.new(env_path) }

  before do
    @env_keys = ENV.keys
  end

  after do
    ENV.delete_if { |k,v| !@env_keys.include?(k) }
  end

  describe 'initialize' do
    it 'reads environment config' do
      expect(dotenv['OPTION_A']).to eq('1')
      expect(dotenv['OPTION_B']).to eq('2')
    end
    it 'fails silently if there is no file' do
      expect { Dotenv::Environment.new('.env_does_not_exist') }.to_not raise_error
    end
  end

  describe 'apply' do
    it 'sets variables in ENV' do
      dotenv.apply
      expect(ENV['OPTION_A']).to eq('1')
    end
  end

  def fixture_path(name)
    File.join(File.expand_path('../fixtures', __FILE__), name)
  end
end