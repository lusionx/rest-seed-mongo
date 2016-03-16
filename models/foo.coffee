_         = require 'lodash'


M =
  a: Number
  id: String


module.exports = (ose, name) ->
  opt =
    strict: no
    id: no
  m = new ose.Schema M, opt
  ose.model name, m, name
