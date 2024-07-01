require "spec_helper"
require_relative "./parser_behavior"
require "tempfile"
require "dotenv/shell_parser"

describe Dotenv::Parser do
  def env(string)
    f = Tempfile.new('.env')
    f.write string
    f.close
    Dotenv::ShellParser.new.source(f.path)
  ensure
    f.unlink
  end

  it_behaves_like "parser"

  it "works" do
    pp env("FOO=bar")
  end
end
