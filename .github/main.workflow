// eslint-disable
workflow "Build, test, lint, release" {
  on       = "push"

  resolves = [
    "Execute `npm run lint`",
    "Executes `npm run release`",
  ]
}

action "Execute `npm ci`" {
  uses = "actions/npm@master"
  args = "ci"
}

action "Execute `npm run lint`" {
  uses  = "actions/npm@master"
  args  = "run lint"

  needs = [
    "Execute `npm ci`"
  ]
}

action "Executes `npm run test`" {
  uses  = "actions/npm@master"
  args  = "run test"

  needs = [
    "Execute `npm ci`"
  ]
}

action "Executes `npm run release:dryrun`" {
  uses    = "actions/npm@master"
  args    = "run release:dryrun"

  needs   = [
    "Executes `npm run test`",
    "Execute `npm run lint`"
  ]

  secrets = [
    "GITHUB_TOKEN",
    "NPM_TOKEN"
  ]
}

action "Releases only if pushed to master branch" {
  uses  = "actions/bin/filter@master"
  args  = "branch master"

  needs = [
    "Executes `npm run release:dryrun`"
  ]
}

action "Executes `npm run release`" {
  uses    = "actions/npm@master"
  args    = "run release"

  needs   = [
    "Releases only if pushed to master branch"
  ]

  secrets = [
    "GITHUB_TOKEN",
    "NPM_TOKEN"
  ]
}
