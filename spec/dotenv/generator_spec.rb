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
      let(:test_file_writer) do
        writer = Dotenv::Generator.new(nil, nil, test_env_file)
        writer.set 'TEST_ONE', 'foo'
        writer.set 'TEST_TWO', 'bar'
        writer
      end
      let(:target_file_writer) do
        writer = Dotenv::Generator.new(nil, nil, target_env_file)
        writer.set 'TARGET_ONE', 'foo'
        writer.set 'TARGET_TWO', 'bar'
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

  describe 'existing' do
    let(:test_env_file) { '.env.test' }
    let(:target_env_file) { 'test.env' }
    let(:test_file_writer) do
      writer = Dotenv::Generator.new(nil, nil, test_env_file)
      writer.set 'TEST_ONE', 'foo'
      writer.set 'TEST_TWO', 'bar'
      writer
    end
    let(:target_file_writer) do
      writer = Dotenv::Generator.new(nil, nil, target_env_file)
      writer.set 'TARGET_ONE', 'foo'
      writer.set 'TARGET_TWO', 'bar'
      writer.set 'TEST_ONE', 'changed'
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
    
    it 'should load and merge values from the environment file and the target file in that order' do
      Dotenv.parse(test_env_file).merge(Dotenv.parse(target_env_file)).each do |k,v|
        expect(subject.existing[k]).to eq(v)
      end
    end
  end

  describe 'examples' do
    subject { Dotenv::Generator.new(nil, fixture_path('plain.env')) }
    
    it 'should load values from the example file' do
      Dotenv.parse(fixture_path('plain.env')).each do |k,v|
        expect(subject.examples[k]).to eq(v)
      end
    end
  end

  describe 'values' do
    subject { Dotenv::Generator.new('test', fixture_path('plain.env')) }
    
    it 'should return a hash with the current key/value pairs' do
      plain = Dotenv.parse(fixture_path('plain.env'))
      subject.values.each do |k,v|
        expect(plain[k]).to eq(v)
      end
    end
  end

  describe 'to_s' do
    subject { Dotenv::Generator.new(nil, fixture_path('plain.env')) }
    
    it 'should return a dotenv file formatted string representation of the key/value pairs' do
      expect(subject.to_s).to eq(subject.values.map { |k,v| "#{k}=#{v}"}.join($/))
    end
  end

  describe 'write' do
    let(:test_env_file) { 'test.env' }
    subject { Dotenv::Generator.new(nil, fixture_path('plain.env'), test_env_file) }
    after { File.unlink(expand(test_env_file)) if File.exists?(expand(test_env_file)) }
    
    it 'should write the key/value pairs to the target file' do
      subject.write
      Dotenv.parse(test_env_file).each do |k,v|
        expect(subject[k]).to eq(v)
      end
    end
  end

  describe 'prompt_for' do
    subject { Dotenv::Generator.new(nil, fixture_path('plain.env')) }
    
    it 'should prompt the user for a value' do
      STDOUT.should_receive(:puts).at_least(:once)
      STDIN.should_receive(:gets).and_return('foobar')
      key = subject.values.keys.first
      subject.prompt_for key
    end
    
    it 'should return the new value if provided' do
      STDOUT.should_receive(:puts).at_least(:once)
      STDIN.should_receive(:gets).and_return('foobar')
      key = subject.values.keys.first
      expect(subject.prompt_for(key)).to eq('foobar')
    end
    
    it 'should return the existing value if none was provided' do
      STDOUT.should_receive(:puts).at_least(:once)
      STDIN.should_receive(:gets).and_return('')
      key = subject.values.keys.first
      expect(subject.prompt_for(key)).to eq(subject[key])
    end
  end

  describe 'prompt' do
    subject do
      g = Dotenv::Generator.new
      g.set 'FOO', 'abc'
      g.set 'BAR', 'xyz'
      g
    end
    
    it 'should update the values hash with the provided input value for each key' do
      STDOUT.should_receive(:puts).at_least(:once)
      STDIN.should_receive(:gets).at_least(:once).and_return('foobar')
      subject.prompt
      subject.values.each do |k,v|
        expect(v).to eq('foobar')
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
