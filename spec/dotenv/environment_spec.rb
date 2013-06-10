require 'spec_helper'

describe Dotenv::Environment do
  subject { env("OPTION_A=1\nOPTION_B=2") }

  describe 'initialize' do
    it 'reads the file' do
      expect(subject['OPTION_A']).to eq('1')
      expect(subject['OPTION_B']).to eq('2')
    end

    it 'fails if file does not exist' do
      expect {
        Dotenv::Environment.new('.does_not_exists')
      }.to raise_error(Errno::ENOENT)
    end
  end

  describe 'apply' do
    it 'sets variables in ENV' do
      subject.apply
      expect(ENV['OPTION_A']).to eq('1')
    end
    
    context 'when not set to override defined variables' do
      it 'does not override defined variables' do
        ENV['OPTION_A'] = 'predefined'
        subject.apply
        expect(ENV['OPTION_A']).to eq('predefined')
      end
    end

    context 'when set to override defined variables' do
      before(:all) { Dotenv.class_variable_set :@@override, true }
      after(:all) { Dotenv.class_variable_set :@@override, false }
      it 'does override defined variables' do
        ENV['OPTION_A'] = 'predefined'
        subject.apply
        expect(ENV['OPTION_A']).to eq('1')
      end
    end
  end

  it 'parses unquoted values' do
    expect(env('FOO=bar')).to eql('FOO' => 'bar')
  end

  it 'parses values with spaces around equal sign' do
    expect(env("FOO =bar")).to eql('FOO' => 'bar')
    expect(env("FOO= bar")).to eql('FOO' => 'bar')
  end

  it 'parses double quoted values' do
    expect(env('FOO="bar"')).to eql('FOO' => 'bar')
  end

  it 'parses single quoted values' do
    expect(env("FOO='bar'")).to eql('FOO' => 'bar')
  end

  it 'parses escaped double quotes' do
    expect(env('FOO="escaped\"bar"')).to eql('FOO' => 'escaped"bar')
  end

  it 'parses yaml style options' do
    expect(env('OPTION_A: 1')).to eql('OPTION_A' => '1')
  end

  it 'parses export keyword' do
    expect(env('export OPTION_A=2')).to eql('OPTION_A' => '2')
  end

  it 'expands newlines in quoted strings' do
    expect(env('FOO="bar\nbaz"')).to eql('FOO' => "bar\nbaz")
  end

  it 'parses varibales with "." in the name' do
    expect(env('FOO.BAR=foobar')).to eql('FOO.BAR' => 'foobar')
  end

  it 'strips unquoted values' do
    expect(env('foo=bar ')).to eql('foo' => 'bar') # not 'bar '
  end

  it 'throws an error if line format is incorrect' do
    expect{env('lol$wut')}.to raise_error(Dotenv::FormatError)
  end

  it 'ignores empty lines' do
    expect(env("\n \t  \nfoo=bar\n \nfizz=buzz")).to eql('foo' => 'bar', 'fizz' => 'buzz')
  end

  it 'ignores inline comments' do
    expect(env("foo=bar # this is foo")).to eql('foo' => 'bar')
  end

  it 'allows # in quoted value' do
    expect(env('foo="bar#baz" # comment')).to eql('foo' => 'bar#baz')
  end

  it 'ignores comment lines' do
    expect(env("\n\n\n # HERE GOES FOO \nfoo=bar")).to eql('foo' => 'bar')
  end

  it 'parses # in quoted values' do
    expect(env('foo="ba#r"')).to eql('foo' => 'ba#r')
    expect(env("foo='ba#r'")).to eql('foo' => 'ba#r')
  end

  require 'tempfile'
  def env(text)
    file = Tempfile.new('dotenv')
    file.write text
    file.close
    env = Dotenv::Environment.new(file.path)
    file.unlink
    env
  end
end
