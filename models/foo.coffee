{Schema}  = require 'mongoose'


M = Schema
  a: String


module.exports = (ose, name) ->
  ose.model name, M
