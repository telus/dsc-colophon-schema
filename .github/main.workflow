workflow "Build, test, lint, release" {
  on = "push"
  resolves = ["Execute `npm run lint`", "GitHub Action for npm-1"]
}

action "Execute `npm run lint`" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "run lint"
}

action "Executes `npm run test`" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  args = "run test"
}

action "GitHub Action for npm" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["Executes `npm run test`", "Execute `npm run lint`"]
  runs = "run release:dryrun"
  secrets = ["GITHUB_TOKEN", "NPM_TOKEN"]
}

action "Releases only if pushed to master branch" {
  uses = "actions/bin/filter@3c0b4f0e63ea54ea5df2914b4fabf383368cd0da"
  needs = ["GitHub Action for npm"]
  args = "branch master"
}

action "GitHub Action for npm-1" {
  uses = "actions/npm@59b64a598378f31e49cb76f27d6f3312b582f680"
  needs = ["Releases only if pushed to master branch"]
  args = "release"
  secrets = ["GITHUB_TOKEN", "NPM_TOKEN"]
}
