_         = require 'lodash'


M =
  a: Number


module.exports = (ose, name) ->
  opt =
    strict: no
  m = new ose.Schema M, opt
  ose.model name, m, name
