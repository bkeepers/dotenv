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

    context 'when the file does not exist' do
      subject { Dotenv.load('.env_does_not_exist') }

      it 'fails silently' do
        expect { subject }.not_to raise_error
        expect(ENV.keys).to eq(@env_keys)
      end
    end

  end

  describe 'load!' do
    context 'with multiple files' do
      context 'when one file exists and one does not' do
        subject { Dotenv.load!('.env', '.env_does_not_exist') }

        it 'raises an Errno::ENOENT error and does not load any files' do
          expect do
            expect do
              subject
            end.to raise_error(Errno::ENOENT)
          end.to_not change { ENV.keys }
        end
      end
    end
  end

  def fixture_path(name)
    File.join(File.expand_path('../fixtures', __FILE__), name)
  end
end
