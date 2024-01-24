require "dotenv"
require "dotenv/autorestore"

def fixture_path(*parts)
  Pathname.new(__dir__).join("./fixtures", *parts)
end
