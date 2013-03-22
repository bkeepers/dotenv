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

    it 'does not override defined variables' do
      ENV['OPTION_A'] = 'predefined'
      subject.apply
      expect(ENV['OPTION_A']).to eq('predefined')
    end
  end

  it 'parses unquoted values' do
    expect(env('FOO=bar')).to eql({'FOO' => 'bar'})
  end

  it 'parses double quoted values' do
    expect(env('FOO="bar"')).to eql({'FOO' => 'bar'})
  end

  it 'parses single quoted values' do
    expect(env("FOO='bar'")).to eql({'FOO' => 'bar'})
  end

  it 'parses escaped double quotes' do
    expect(env('FOO="escaped\"bar"')).to eql({'FOO' => 'escaped"bar'})
  end

  it 'parses yaml style options' do
    expect(env("OPTION_A: 1")).to eql('OPTION_A' => '1')
  end

  it 'parses export keyword' do
    expect(env("export OPTION_A=2")).to eql('OPTION_A' => '2')
  end

  it 'expands newlines in quoted strings' do
    expect(env('FOO="bar\nbaz"')).to eql({"FOO" => "bar\nbaz"})
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
