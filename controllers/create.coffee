utils   = require '../lib/utils'


index = [
  (req, res, next) ->
    M = utils.model req.params.col
    M.create req.body, (err, m) ->
      return next err if err
      res.json m
      next()
]


module.exports = {index}
