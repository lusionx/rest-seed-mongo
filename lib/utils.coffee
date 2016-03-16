_         = require 'lodash'
async     = require 'async'
mongoose  = require 'mongoose'
rest      = require 'rest-seed'
log4js    = require 'log4js'
conf      = require '../configs'


utils =
  model: (a) ->
    mongoose.model a
  getLogger: (k) ->
    l = log4js.getLogger k
    if k and not l._events
      log4js.addAppender log4js.appenders.console(), k
      return log4js.getLogger k
    l

  selfPath: (f) ->
    p = path.relative process.argv[1], f
    p.replace(/\.\.\//g, '')

module.exports = _.extend utils, rest.utils
