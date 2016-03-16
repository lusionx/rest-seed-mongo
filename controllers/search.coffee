utils   = require '../lib/utils'
helper  = require './helper'


index = [
  (req, res, next) ->
    M = utils.model req.params.col
    M.find {}, (err, m) ->
      return next err if err
      res.json m
      next()
]

byid = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  helper.rest.byid 'Model', 'id', 'm'
  helper.assert.exists 'm'
  helper.rest.send 'm'
]


module.exports = {index, byid}
