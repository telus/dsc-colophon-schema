workflow "Build, test, lint, release" {
  on = "push"
  resolves = ["Execute `npm run lint`", "GitHub Action for npm-1"]
}

action "Execute `npm ci`" {
  uses = "actions/npm@master"
  args = "ci"
}

action "Execute `npm run lint`" {
  needs = ["Execute `npm ci`"]
  uses = "actions/npm@master"
  args = "run lint"
}

action "Executes `npm run test`" {
  needs = ["Execute `npm ci`"]
  uses = "actions/npm@master"
  args = "run test"
}

action "GitHub Action for npm" {
  uses = "actions/npm@master"
  needs = ["Executes `npm run test`", "Execute `npm run lint`"]
  runs = "run release:dryrun"
  secrets = ["GITHUB_TOKEN", "NPM_TOKEN"]
}

action "Releases only if pushed to master branch" {
  uses = "actions/bin/filter@master"
  needs = ["GitHub Action for npm"]
  args = "branch master"
}

action "GitHub Action for npm-1" {
  uses = "actions/npm@master"
  needs = ["Releases only if pushed to master branch"]
  args = "release"
  secrets = ["GITHUB_TOKEN", "NPM_TOKEN"]
}
