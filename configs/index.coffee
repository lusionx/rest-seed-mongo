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
  models: ['-system.indexes', 'foo2']
  schema:
    timestamps: yes

module.exports = _.extend {}, ext, conf
