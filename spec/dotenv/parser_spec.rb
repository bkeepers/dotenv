require "spec_helper"
require_relative "./parser_behavior"

describe Dotenv::Parser do
  def env(string)
    Dotenv::Parser.call(string)
  end

  it_behaves_like "parser"

  context "deprecated behavior" do
    it "parses unquoted values with spaces after seperator" do
      expect(env("FOO= bar")).to eql("FOO" => "bar")
    end

    it "parses values with spaces around equal sign" do
      expect(env("FOO =bar")).to eql("FOO" => "bar")
      expect(env("FOO= bar")).to eql("FOO" => "bar")
    end
  end

end
