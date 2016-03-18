_     = require 'lodash'

conf = require "./config.#{process.env.webmode or 'development'}"

ext =
  privateIps: [
  ]
  privateEmails: [
  ]

  search:
    LIMIT: 10
    LIMIT_MAX: 1000
module.exports = _.extend {}, ext, conf
