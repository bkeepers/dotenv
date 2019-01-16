workflow "Publish Gems" {
  on = "push"
  resolves = [
    "Release dotenv",
    "Release dotenv-rails",
  ]
}

action "Tag Filter" {
  uses = "actions/bin/filter@master"
  args = "tag v*"
}

action "Release dotenv" {
  uses = "cadwallion/publish-rubygems-action@master"
  needs = ["Tag Filter"]
  secrets = ["GITHUB_TOKEN", "RUBYGEMS_API_KEY"]
  env = {
    RELEASE_COMMAND = "rake dotenv:release"
  }
}

action "Release dotenv-rails" {
  uses = "cadwallion/publish-rubygems-action@master"
  needs = ["Tag Filter"]
  secrets = ["GITHUB_TOKEN", "RUBYGEMS_API_KEY"]
  env = {
    RELEASE_COMMAND = "rake dotenv-rails:release"
  }
}
