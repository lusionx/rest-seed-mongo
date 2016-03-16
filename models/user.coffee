{Schema}  = require 'mongoose'


M = Schema
  id: String
  name: String


module.exports = (ose, name) ->
  ose.model name, M
