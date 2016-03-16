utils   = require '../lib/utils'


index = [
  (req, res, next) ->
    M = utils.model req.params.col
    M.find {}, (err, m) ->
      return next err if err
      res.json m
      next()
]

byid = [
  (req, res, next) ->
    M = utils.model req.params.col
    M.findById req.params.id, (err, m) ->
      return next err if err
      res.json m
      next()
]


module.exports = {index, byid}
