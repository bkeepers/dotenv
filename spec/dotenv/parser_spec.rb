require 'spec_helper'

describe Dotenv::Parser do
  def env(string)
    Dotenv::Parser.call(string)
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

  it 'parses empty values' do
    expect(env('FOO=')).to eql('FOO' => '')
  end

  it 'expands variables found in values' do
    expect(env("FOO=test\nBAR=$FOO")).to eql('FOO' => 'test', 'BAR' => 'test')
  end

  it 'parses variables wrapped in brackets' do
    expect(env("FOO=test\nBAR=${FOO}bar")).to eql('FOO' => 'test', 'BAR' => 'testbar')
  end

  it 'reads variables from ENV when expanding if not found in local env' do
    ENV['FOO'] = 'test'
    expect(env('BAR=$FOO')).to eql('BAR' => 'test')
  end

  it 'expands undefined variables to an empty string' do
    expect(env('BAR=$FOO')).to eql('BAR' => '')
  end

  it 'expands variables in double quoted strings' do
    expect(env("FOO=test\nBAR=\"quote $FOO\"")).to eql('FOO' => 'test', 'BAR' => 'quote test')
  end

  it 'does not expand variables in single quoted strings' do
    expect(env("BAR='quote $FOO'")).to eql('BAR' => 'quote $FOO')
  end

  it 'does not expand escaped variables' do
    expect(env('FOO="foo\$BAR"')).to eql('FOO' => 'foo$BAR')
    expect(env('FOO="foo\${BAR}"')).to eql('FOO' => 'foo${BAR}')
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

  it 'parses variables with "." in the name' do
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

  if RUBY_VERSION > '1.8.7'
    it 'parses shell commands interpolated in $()' do
      expect(env('ruby_v=$(ruby -v)')).to eql('ruby_v' => RUBY_DESCRIPTION)
    end

    it 'allows balanced parentheses within interpolated shell commands' do
      expect(env('ruby_v=$(echo "$(echo "$(echo "$(ruby -v)")")")')).to eql('ruby_v' => RUBY_DESCRIPTION)
    end

    it "doesn't interpolate shell commands when escape says not to" do
      expect(env('ruby_v=escaped-\$(ruby -v)')).to eql('ruby_v' => 'escaped-$(ruby -v)')
    end

    it 'is not thrown off by quotes in interpolated shell commands' do
      expect(env('interp=$(echo "Quotes won\'t be a problem")')['interp']).to eql("Quotes won't be a problem")
    end

    # This functionality is not supported on JRuby or Rubinius
    if (!defined?(RUBY_ENGINE) || RUBY_ENGINE != 'jruby') && !defined?(Rubinius)
      it 'substitutes shell variables within interpolated shell commands' do
        expect(env(%(VAR1=var1\ninterp=$(echo "VAR1 is $VAR1")))['interp']).to eql("VAR1 is var1")
      end
    end
  end

end
