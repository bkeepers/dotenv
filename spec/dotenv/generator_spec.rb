require 'dotenv/generator'
require 'spec_helper'

describe Dotenv::Generator do
  subject { Dotenv::Generator.new(nil, 'example.env', 'target.env') }

  describe 'initialize' do
    it 'should expand the path of the target file' do
      expect(subject.target_file).to eq(expand('target.env'))
    end

    it 'should expand the path of the example file' do
      expect(subject.example_file).to eq(expand('example.env'))
    end

    context 'with no target file provided' do
      let(:test_env_file) { '.env.test' }
      let(:test_file_loader) { Dotenv::Generator.new(nil, nil, fixture_path('plain.env')) }
      let(:test_file_writer) do
        writer = Dotenv::Generator.new(nil, nil, test_env_file)
        test_file_loader.values.each { |k,v| writer.set k,v }
        writer
      end
      
      before { test_file_writer.write }
      after { File.unlink test_file_writer.target_file }
      subject { Dotenv::Generator.new('test') }

      it 'should target .env.ENVIRONMENT' do
        expect(subject.target_file).to eq(expand(test_env_file))
      end
      
      it 'should load existing values from .env.ENVIRONMENT' do
        test_file_loader.values.each do |k,v|
          expect(subject[k]).to eq(v)
        end
      end
    end

    context 'with a target file provided' do
      subject { Dotenv::Generator.new(nil, nil, fixture_path('plain.env')) }

      it 'should target the provided file' do
        expect(subject.target_file).to eq(expand(fixture_path('plain.env')))
      end
      
      it 'should load existing values from the provided file' do
        Dotenv.parse(fixture_path('plain.env')).each do |k,v|
          expect(subject[k]).to eq(v)
        end
      end
    end

    context 'with no environment or target file provided' do
      let(:test_env_file) { '.env' }
      subject { Dotenv::Generator.new }
      
      it 'should target .env' do
        expect(subject.target_file).to eq(expand(test_env_file))
      end

      it 'should load existing values from .env' do
        Dotenv.parse('.env').each do |k,v|
          expect(subject[k]).to eq(v)
        end
      end
    end

    context 'with an environment and a target file provided' do
      let(:test_env_file) { '.env.test' }
      let(:target_env_file) { 'test.env' }
      #let(:test_file_loader) { Dotenv::Generator.new(nil, nil, fixture_path('plain.env')) }
      let(:test_file_writer) do
        writer = Dotenv::Generator.new(nil, nil, test_env_file)
        writer.set "TEST_ONE", "foo"
        writer.set "TEST_TWO", "bar"
        writer
      end
      let(:target_file_writer) do
        writer = Dotenv::Generator.new(nil, nil, target_env_file)
        writer.set "TARGET_ONE", "foo"
        writer.set "TARGET_TWO", "bar"
        writer
      end
      
      before do
        test_file_writer.write
        target_file_writer.write
      end
      after do 
        File.unlink(test_file_writer.target_file)
        File.unlink(target_file_writer.target_file)
      end
      subject { Dotenv::Generator.new('test', nil, target_env_file) }
      
      it 'should target the provided file' do
        expect(subject.target_file).to eq(expand(target_env_file))
      end

      it 'should load and merge existing values from .env.ENVIRONMENT and the provided target file' do
        Dotenv.parse(test_env_file).merge(Dotenv.parse(target_env_file)).each do |k,v|
          expect(subject[k]).to eq(v)
        end
      end
    end

    context 'with no example file provided' do
      subject { Dotenv::Generator.new }
      
      it 'should use .env.example' do
        expect(subject.example_file).to eq(expand('.env.example'))
      end
    end

    context 'with an example file provided' do
      subject { Dotenv::Generator.new(nil, 'example.env') }
      
      it 'should use the provided file' do
        expect(subject.example_file).to eq(expand('example.env'))
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
