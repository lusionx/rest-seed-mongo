_           = require 'lodash'
log4js      = require 'log4js'
path        = require 'path'
rest        = require './rest'

config      = require './configs'


console.log config

log4js.configure
  appenders: [
      type: 'console'
      category: 'default'
  ]

rest __dirname
