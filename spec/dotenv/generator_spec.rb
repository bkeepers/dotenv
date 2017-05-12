require "spec_helper"
require "dotenv/generator"

describe Dotenv::Generator do
  def string(*args)
    Dotenv::Generator.call(*args)
  end

  def env(string)
    Dotenv::Parser.call(string)
  end

  def with_env(k, v)
    old = ENV[k]
    ENV[k] = v
    yield
  ensure
    ENV[k] = old
  end

  def back_and_forth(env, string)
    expect(string(env)).to eq(string)
    expect(env(string)).to eq(env)
  end

  it "generates empty" do
    back_and_forth({}, "\n")
  end

  it "generates simple values" do
    back_and_forth({ "FOO" => "bar" }, "FOO=\"bar\"\n")
  end

  it "generates escaped double quotes" do
    back_and_forth({ "FOO" => 'escaped"bar' }, "FOO=\"escaped\\\"bar\"\n")
  end

  it "generates empty values" do
    back_and_forth({ "FOO" => "" }, "FOO=\"\"\n")
  end

  it "generates with escaped variables" do
    back_and_forth({ "BAR" => "quote $FOOBAR" }, "BAR=\"quote \\$FOOBAR\"\n")
  end

  describe "unsafe" do
    it "can generate with variables" do
      with_env("FOOBAR", "111") do
        string = string({ "BAR" => "quote $FOOBAR" }, :unsafe => true)
        expect(string).to eq "BAR=\"quote $FOOBAR\"\n"
        expect(env(string)).to eq "BAR" => "quote 111"
      end
    end

    it "can prevent variables with escapes in unsafe mode" do
      with_env("FOOBAR", "111") do
        string = string({ "BAR" => "quote \\$FOOBAR" }, :unsafe => true)
        expect(string).to eq "BAR=\"quote \\\\$FOOBAR\"\n"
        expect(env(string)).to eq "BAR" => "quote $FOOBAR"
      end
    end
  end

  it "generates newlines in quoted strings" do
    back_and_forth({ "FOO" => "bar\nbaz" }, "FOO=\"bar\\nbaz\"\n")
  end

  it "allows # in quoted value" do
    back_and_forth({ "foo" => "bar#baz" }, "foo=\"bar#baz\"\n")
  end
end
