#!/usr/bin/env node
/* eslint-disable no-console */

const parser = require('./index.js')
const fs = require('fs')

const { argv } = require('yargs')
  .usage('Usage: $0 <command> [options]')
  .command('colophon-validator', 'Validate Colophon file schema.')
  .example('$0 -f .colophon.yml', 'Validate Colophon file schema.')
  .alias('f', 'file')
  .nargs('f', 1)
  .describe('f', 'Load a file')
  .default('f', '.colophon.yml')
  .help('h')
  .alias('h', 'help')
  .epilog('Copyright 2020')


function loadYaml() {
  try {
    return fs.readFileSync(argv.file, 'utf8')
  } catch(err) {
    console.error(`"${argv.file}" doesnt exist!`)
    return process.exit(1)
  }
}

async function validateSchema(yaml) {
  try {
    await parser(yaml)
    console.log('Colophon validation successful.')
  } catch(err) {
    console.error('Colophon validation failed.\n', err.errors)
  }
}

validateSchema(loadYaml())
