require "spec_helper"
require "dotenv/cli"

describe "dotenv binary" do
  before do
    Dir.chdir(File.expand_path("../../fixtures", __FILE__))
  end

  def run(*args)
    Dotenv::CLI.new(args).run
  end

  it "loads from .env by default" do
    expect(ENV).not_to have_key("DOTENV")
    run
    expect(ENV).to have_key("DOTENV")
  end

  it "loads from file specified by -f" do
    expect(ENV).not_to have_key("OPTION_A")
    run "-f", "plain.env"
    expect(ENV).to have_key("OPTION_A")
  end

  it "dies if file specified by -f doesn't exist" do
    expect do
      capture_output { run "-f", ".doesnotexist" }
    end.to raise_error(SystemExit, /No such file/)
  end

  it "loads from multiple files specified by -f" do
    expect(ENV).not_to have_key("PLAIN")
    expect(ENV).not_to have_key("QUOTED")

    run "-f", "plain.env,quoted.env"

    expect(ENV).to have_key("PLAIN")
    expect(ENV).to have_key("QUOTED")
  end

  # Capture output to $stdout and $stderr
  def capture_output(&_block)
    original_stderr = $stderr
    original_stdout = $stdout
    output = $stderr = $stdout = StringIO.new

    yield

    $stderr = original_stderr
    $stdout = original_stdout
    output.string
  end
end
