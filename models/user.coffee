M =
  id: String
  name: String


module.exports = (ose, name) ->
  opt =
    strict: no
  m = new ose.Schema M, opt
  ose.model name, m, name
