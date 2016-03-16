utils   = require '../lib/utils'


index = [
  (req, res, next) ->
    M = utils.model req.params.col
    M.findById req.params.id, (err, m) ->
      return next err if err
      req.hooks.m = m
      next()
  (req, res, next) ->
    req.hooks.m.remove (err) ->
      return next err if err
      res.send 204
      next()
]


module.exports = {index}
