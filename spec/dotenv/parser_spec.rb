require "spec_helper"

describe Dotenv::Parser do
  def env(string)
    Dotenv::Parser.call(string, true)
  end

  it "parses unquoted values" do
    expect(env("FOO=bar")).to eql("FOO" => "bar")
  end

  it "parses unquoted values with spaces after seperator" do
    expect(env("FOO= bar")).to eql("FOO" => "bar")
  end

  it "parses values with spaces around equal sign" do
    expect(env("FOO =bar")).to eql("FOO" => "bar")
    expect(env("FOO= bar")).to eql("FOO" => "bar")
  end

  it "parses values with leading spaces" do
    expect(env("  FOO=bar")).to eql("FOO" => "bar")
  end

  it "parses values with following spaces" do
    expect(env("FOO=bar  ")).to eql("FOO" => "bar")
  end

  it "parses double quoted values" do
    expect(env('FOO="bar"')).to eql("FOO" => "bar")
  end

  it "parses double quoted values with following spaces" do
    expect(env('FOO="bar"  ')).to eql("FOO" => "bar")
  end

  it "parses single quoted values" do
    expect(env("FOO='bar'")).to eql("FOO" => "bar")
  end

  it "parses single quoted values with following spaces" do
    expect(env("FOO='bar'  ")).to eql("FOO" => "bar")
  end

  it "parses escaped double quotes" do
    expect(env('FOO="escaped\"bar"')).to eql("FOO" => 'escaped"bar')
  end

  it "parses empty values" do
    expect(env("FOO=")).to eql("FOO" => "")
  end

  it "expands variables found in values" do
    expect(env("FOO=test\nBAR=$FOO")).to eql("FOO" => "test", "BAR" => "test")
  end

  it "parses variables wrapped in brackets" do
    expect(env("FOO=test\nBAR=${FOO}bar"))
      .to eql("FOO" => "test", "BAR" => "testbar")
  end

  it "expands variables from ENV if not found in .env" do
    ENV["FOO"] = "test"
    expect(env("BAR=$FOO")).to eql("BAR" => "test")
  end

  it "expands variables from ENV if found in .env during load" do
    ENV["FOO"] = "test"
    expect(env("FOO=development\nBAR=${FOO}")["BAR"])
      .to eql("test")
  end

  it "doesn't expand variables from ENV if in local env in overload" do
    ENV["FOO"] = "test"
    expect(env("FOO=development\nBAR=${FOO}")["BAR"])
      .to eql("test")
  end

  it "expands undefined variables to an empty string" do
    expect(env("BAR=$FOO")).to eql("BAR" => "")
  end

  it "expands variables in double quoted strings" do
    expect(env("FOO=test\nBAR=\"quote $FOO\""))
      .to eql("FOO" => "test", "BAR" => "quote test")
  end

  it "does not expand variables in single quoted strings" do
    expect(env("BAR='quote $FOO'")).to eql("BAR" => "quote $FOO")
  end

  it "does not expand escaped variables" do
    expect(env('FOO="foo\$BAR"')).to eql("FOO" => "foo$BAR")
    expect(env('FOO="foo\${BAR}"')).to eql("FOO" => "foo${BAR}")
    expect(env("FOO=test\nBAR=\"foo\\${FOO} ${FOO}\""))
      .to eql("FOO" => "test", "BAR" => "foo${FOO} test")
  end

  it "parses yaml style options" do
    expect(env("OPTION_A: 1")).to eql("OPTION_A" => "1")
  end

  it "parses export keyword" do
    expect(env("export OPTION_A=2")).to eql("OPTION_A" => "2")
  end

  it "allows export line if you want to do it that way" do
    expect(env('OPTION_A=2
export OPTION_A')).to eql("OPTION_A" => "2")
  end

  it "allows export line if you want to do it that way and checks for unset"\
     " variables" do
    expect do
      env('OPTION_A=2
export OH_NO_NOT_SET')
    end.to raise_error(Dotenv::FormatError, 'Line "export OH_NO_NOT_SET"'\
                                            " has an unset variable")
  end

  it "expands newlines in quoted strings" do
    expect(env('FOO="bar\nbaz"')).to eql("FOO" => "bar\nbaz")
  end

  it 'parses variables with "." in the name' do
    expect(env("FOO.BAR=foobar")).to eql("FOO.BAR" => "foobar")
  end

  it "strips unquoted values" do
    expect(env("foo=bar ")).to eql("foo" => "bar") # not 'bar '
  end

  it "ignores lines that are not variable assignments" do
    expect(env("lol$wut")).to eql({})
  end

  it "ignores empty lines" do
    expect(env("\n \t  \nfoo=bar\n \nfizz=buzz"))
      .to eql("foo" => "bar", "fizz" => "buzz")
  end

  it "ignores inline comments" do
    expect(env("foo=bar # this is foo")).to eql("foo" => "bar")
  end

  it "allows # in quoted value" do
    expect(env('foo="bar#baz" # comment')).to eql("foo" => "bar#baz")
  end

  it "allows # in quoted value with spaces after seperator" do
    expect(env('foo= "bar#baz" # comment')).to eql("foo" => "bar#baz")
  end

  it "ignores comment lines" do
    expect(env("\n\n\n # HERE GOES FOO \nfoo=bar")).to eql("foo" => "bar")
  end

  it "ignores commented out variables" do
    expect(env("# HELLO=world\n")).to eql({})
  end

  it "ignores comment" do
    expect(env("# Uncomment to activate:\n")).to eql({})
  end

  it "includes variables without values" do
    input = 'DATABASE_PASSWORD=
DATABASE_USERNAME=root
DATABASE_HOST=/tmp/mysql.sock'

    output = {
      "DATABASE_PASSWORD" => "",
      "DATABASE_USERNAME" => "root",
      "DATABASE_HOST" => "/tmp/mysql.sock"
    }

    expect(env(input)).to eql(output)
  end

  it "parses # in quoted values" do
    expect(env('foo="ba#r"')).to eql("foo" => "ba#r")
    expect(env("foo='ba#r'")).to eql("foo" => "ba#r")
  end

  it "parses # in quoted values with following spaces" do
    expect(env('foo="ba#r"  ')).to eql("foo" => "ba#r")
    expect(env("foo='ba#r'  ")).to eql("foo" => "ba#r")
  end

  it "parses empty values" do
    expect(env("foo=")).to eql("foo" => "")
  end

  it "allows multi-line values in single quotes" do
    env_file = %(OPTION_A=first line
export OPTION_B='line 1
line 2
line 3'
OPTION_C="last line"
OPTION_ESCAPED='line one
this is \\'quoted\\'
one more line')

    expected_result = {
      "OPTION_A" => "first line",
      "OPTION_B" => "line 1\nline 2\nline 3",
      "OPTION_C" => "last line",
      "OPTION_ESCAPED" => "line one\nthis is \\'quoted\\'\none more line"
    }
    expect(env(env_file)).to eql(expected_result)
  end

  it "allows multi-line values in double quotes" do
    env_file = %(OPTION_A=first line
export OPTION_B="line 1
line 2
line 3"
OPTION_C="last line"
OPTION_ESCAPED="line one
this is \\"quoted\\"
one more line")

    expected_result = {
      "OPTION_A" => "first line",
      "OPTION_B" => "line 1\nline 2\nline 3",
      "OPTION_C" => "last line",
      "OPTION_ESCAPED" => "line one\nthis is \"quoted\"\none more line"
    }
    expect(env(env_file)).to eql(expected_result)
  end

  if RUBY_VERSION > "1.8.7"
    it "parses shell commands interpolated in $()" do
      expect(env("echo=$(echo hello)")).to eql("echo" => "hello")
    end

    it "allows balanced parentheses within interpolated shell commands" do
      expect(env('echo=$(echo "$(echo "$(echo "$(echo hello)")")")'))
        .to eql("echo" => "hello")
    end

    it "doesn't interpolate shell commands when escape says not to" do
      expect(env('echo=escaped-\$(echo hello)'))
        .to eql("echo" => "escaped-$(echo hello)")
    end

    it "is not thrown off by quotes in interpolated shell commands" do
      expect(env('interp=$(echo "Quotes won\'t be a problem")')["interp"])
        .to eql("Quotes won't be a problem")
    end

    it "supports carriage return" do
      expect(env("FOO=bar\rbaz=fbb")).to eql("FOO" => "bar", "baz" => "fbb")
    end

    it "supports carriage return combine with new line" do
      expect(env("FOO=bar\r\nbaz=fbb")).to eql("FOO" => "bar", "baz" => "fbb")
    end

    it "expands carriage return in quoted strings" do
      expect(env('FOO="bar\rbaz"')).to eql("FOO" => "bar\rbaz")
    end

    it "escape $ properly when no alphabets/numbers/_  are followed by it" do
      expect(env("FOO=\"bar\\$ \\$\\$\"")).to eql("FOO" => "bar$ $$")
    end

    # echo bar $ -> prints bar $ in the shell
    it "ignore $ when it is not escaped and no variable is followed by it" do
      expect(env("FOO=\"bar $ \"")).to eql("FOO" => "bar $ ")
    end

    # This functionality is not supported on JRuby or Rubinius
    if (!defined?(RUBY_ENGINE) || RUBY_ENGINE != "jruby") &&
       !defined?(Rubinius)
      it "substitutes shell variables within interpolated shell commands" do
        expect(env(%(VAR1=var1\ninterp=$(echo "VAR1 is $VAR1")))["interp"])
          .to eql("VAR1 is var1")
      end
    end
  end
end
