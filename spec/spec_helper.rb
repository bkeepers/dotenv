require "dotenv"
require "dotenv/test_help"

def fixture_path(*parts)
  Pathname.new(__dir__).join("./fixtures", *parts)
end
