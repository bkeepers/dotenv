require 'spec_helper'
require 'dotenv/cli'

describe 'dotenv binary' do
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
    run "-f", "spec/fixtures/plain.env"
    expect(ENV).to have_key("OPTION_A")
  end

  it "dies if file specified by -f doesn't exist" do
    expect {
      capture_output { run "-f", ".doesnotexist" }
    }.to raise_error(SystemExit, /No such file/)
  end

  it "loads from multiple files specified by -f" do
    expect(ENV).not_to have_key("PLAIN")
    expect(ENV).not_to have_key("QUOTED")

    run "-f", "spec/fixtures/plain.env,spec/fixtures/quoted.env"

    expect(ENV).to have_key("PLAIN")
    expect(ENV).to have_key("QUOTED")
  end

  # Capture output to $stdout and $stderr
  def capture_output(&block)
    original_stderr, original_stdout = $stderr, $stdout
    output = $stderr = $stdout = StringIO.new

    yield

    $stderr, $stdout = original_stderr, original_stdout
    output.string
  end
end
