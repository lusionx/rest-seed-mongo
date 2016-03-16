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
mongoose.connect config.db

require('./models')(mongoose)

rest = require './rest'
rest __dirname
