require 'spec_helper'

describe Dotenv do
  shared_examples 'load' do
    context 'with no args' do
      let(:env_files) { [] }

      it 'defaults to .env' do
        Dotenv::Environment.should_receive(:new).with(expand('.env')).
          and_return(double(:apply => {}))
        subject
      end
    end

    context 'with a tilde path' do
      let(:env_files) { ['~/.env'] }

      it 'expands the path' do
        expected = expand("~/.env")
        File.stub(:exists?){ |arg| arg == expected }
        Dotenv::Environment.should_receive(:new).with(expected).
          and_return(double(:apply => {}))
        subject
      end
    end

    context 'with multiple files' do
      let(:env_files) { ['.env', fixture_path('plain.env')] }

      let(:expected) do
        { 'OPTION_A' => '1',
          'OPTION_B' => '2',
          'OPTION_C' => '3',
          'OPTION_D' => '4',
          'OPTION_E' => '5',
          'DOTENV' => 'true' }
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

  describe 'load' do
    subject { Dotenv.load(*env_files) }

    it_behaves_like 'load'

    context 'when the file does not exist' do
      let(:env_files) { ['.env_does_not_exist'] }

      it 'fails silently' do
        expect { subject }.not_to raise_error
        expect(ENV.keys).to eq(@env_keys)
      end
    end
  end

  describe 'load!' do
    subject { Dotenv.load!(*env_files) }

    it_behaves_like 'load'

    context 'when one file exists and one does not' do
      let(:env_files) { ['.env', '.env_does_not_exist'] }

      it 'raises an Errno::ENOENT error and does not load any files' do
        expect do
          expect do
            subject
          end.to raise_error(Errno::ENOENT)
        end.to_not change { ENV.keys }
      end
    end
  end

  describe 'add' do
    let(:key) { 'GITHUB_TOKEN'}
    let(:value) { '68e74e7895cf774e97ad12282f7bec8937fb65a4'}
    let(:dotenv_path) { "/var/www/app/.env" }

    context 'when no filename' do
      it 'writes to .env' do
        expect(File).to receive(:expand_path) { dotenv_path }
        expect(File).to receive(:exists?) { true }
        expect(File).to receive(:open).with(dotenv_path, 'a') { double(:puts => nil) }
        Dotenv.add "#{key}=#{value}"
      end
    end

    context 'when file not exists' do
      it 'creates and writes' do
        expect(File).to receive(:expand_path) { dotenv_path }
        expect(File).to receive(:exists?) { false }
        expect(File).to receive(:open).with(dotenv_path, 'w') { double(:puts => nil) }
        Dotenv.add "#{key}=#{value}"
      end
    end

    context 'with specified file' do
      let(:dotenv_path) { "/var/www/app/plain.env" }

      it 'writes to specified file' do
        expect(File).to receive(:expand_path) { dotenv_path }
        expect(File).to receive(:exists?) { true }
        expect(File).to receive(:open).with(dotenv_path, 'a') { double(:puts => nil) }
        Dotenv.add "#{key}=#{value}", 'plain.env'
      end
    end
  end

  def fixture_path(name)
    File.join(File.expand_path('../fixtures', __FILE__), name)
  end

  def expand(path)
    File.expand_path path
  end
end
