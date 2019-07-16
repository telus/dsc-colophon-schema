const { safeLoad } = require('js-yaml')
const Ajv = require('ajv')
const ColophonError = require('./error')
const versions = require('./versions')

// force async

const ajv = new Ajv({ allErrors: true })

module.exports = function parser (data) {
  // attempt to read yaml
  if (!data) {
    return Promise.reject(new Error('Received invalid data'))
  }

  if (typeof data === 'string') {
    try {
      data = safeLoad(data)
    } catch (error) {
      /* istanbul ignore next */
      return Promise.reject(error)
    }
  }

  // load latest and prev to latest version
  // for backwards compatibility
  const { schema } = versions[parseFloat(data.version).toFixed(1)]
  schema['$async'] = true
  const validate = ajv.compile(schema)

  // validate
  return validate(data)
    .then(data)
    .catch(error => {
      // something else went wrong
      /* istanbul ignore if */
      if (!(error instanceof Ajv.ValidationError)) throw error

      // identifiable error class
      throw new ColophonError(error.errors)
    })
}
