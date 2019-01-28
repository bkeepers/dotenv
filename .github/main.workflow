workflow "Publish Gems" {
  resolves = [
    "Release dotenv",
    "Release dotenv-rails",
  ]
  on = "release"
}

action "Release dotenv" {
  uses = "cadwallion/publish-rubygems-action@master"
  secrets = ["GITHUB_TOKEN", "RUBYGEMS_API_KEY"]
  env = {
    RELEASE_COMMAND = "rake dotenv:release"
  }
}

action "Release dotenv-rails" {
  uses = "cadwallion/publish-rubygems-action@master"
  secrets = ["GITHUB_TOKEN", "RUBYGEMS_API_KEY"]
  env = {
    RELEASE_COMMAND = "rake dotenv-rails:release"
  }
}
