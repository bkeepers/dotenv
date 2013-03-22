require 'spec_helper'

describe Dotenv do
  let(:env_path) { fixture_path('plain.env') }

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

  def fixture_path(name)
    File.join(File.expand_path('../fixtures', __FILE__), name)
  end
end
