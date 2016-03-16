

module.exports = (Schema) ->
  M =
    id: String
    name: String
  opt =
    strict: no
    id: no
  new Schema M, opt
