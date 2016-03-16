_         = require 'lodash'




module.exports = (Schema) ->
  M =
    a: Number
    id: String
  opt =
    strict: no
    id: no
  new Schema M, opt
