require 'spec_helper'

describe Dotenv do
  let(:env_path) { fixture_path('plain.env') }

  before do
    @env_keys = ENV.keys
  end

  after do
    ENV.delete_if { |k,v| !@env_keys.include?(k) }
  end

  describe 'load' do
    context 'with no args' do
      it 'defaults to .env' do
        Dotenv::Environment.should_receive(:new).with('.env').
          and_return(mock(:apply => {}))
        Dotenv.load
      end
    end

    context 'with multiple files' do
      let(:expected) do
        {'OPTION_A' => '1', 'OPTION_B' => '2', 'DOTENV' => 'true'}
      end

      subject do
        Dotenv.load('.env', env_path)
      end

      it 'loads all files' do
        subject
        expected.each do |key, value|
          expect(ENV[key]).to eq(value)
        end
      end

      it 'returns hash of loaded environments' do
        expect(subject).to eq(expected)
      end
    end
  end

  describe Dotenv::Environment do
    subject { Dotenv::Environment.new(env_path) }

    context 'with a plain env file' do

      describe 'initialize' do
        it 'reads environment config' do
          expect(subject['OPTION_A']).to eq('1')
          expect(subject['OPTION_B']).to eq('2')
        end
      end

      describe 'apply' do
        it 'sets variables in ENV' do
          subject.apply
          expect(ENV['OPTION_A']).to eq('1')
        end
      end
    end

    context 'when the file does not exist' do
      let(:env_path) { fixture_path('.env_does_not_exist') }

      describe 'initialize' do
        it 'fails silently' do
          expect { Dotenv::Environment.new('.env_does_not_exist') }.not_to raise_error
        end
      end

      describe 'apply' do
        it 'does not effect env' do
          subject.apply
          expect(ENV.keys).to eq(@env_keys)
        end
      end
    end

  end

  def fixture_path(name)
    File.join(File.expand_path('../fixtures', __FILE__), name)
  end
end