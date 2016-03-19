_           = require 'lodash'

config = require './configs'
console.log config

log4js = require 'log4js'
log4js.configure
  appenders: [
      type: 'console'
      category: 'default'
  ]


mongoose = require 'mongoose'
mongoose.set 'debug', yes
mongoose.connect config.db
db = mongoose.connection
db.on 'error', (err) ->
  console.error err
db.once 'open', () -> console.error 'mongoose open'

_.each config.models, (name) ->
  m = new mongoose.Schema {},
    strict: no
    id: no
  mongoose.model name, m, name
console.log mongoose.modelNames()

rest = require 'rest-seed'
rest __dirname
