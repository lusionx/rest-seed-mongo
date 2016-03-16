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

require('./models')(mongoose)
console.log mongoose.modelNames()

rest = require 'rest-seed'
rest __dirname
