require "dotenv"
require "dotenv/autorestore"
require "tmpdir"

def fixture_path(*parts)
  Pathname.new(__dir__).join("./fixtures", *parts)
end

# Capture output to $stdout and $stderr
def capture_output(&_block)
  original_stderr = $stderr
  original_stdout = $stdout
  output = $stderr = $stdout = StringIO.new
  yield
  output.string
ensure
  $stderr = original_stderr
  $stdout = original_stdout
end
