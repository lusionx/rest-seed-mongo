_       = require 'lodash'
async   = require 'async'

utils   = require '../lib/utils'
helper  = require './helper'

logger  = utils.getLogger 'ctr-search'


index = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  (req, res, next) ->
    M = req.hooks.Model
    page =
      skip: +req.query.skip or 0
      limit: +req.query.limit or 10
    query = {}
    v = req.query.q
    if v and m = /^(.+?):(.+?)$/.exec v
      query[m[1]] = m[2]
    M.find query, null, page, (err, m) ->
      return next err if err
      res.json m
      next()
]

query = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  (req, res, next) ->
    M = req.hooks.Model
    page =
      skip: +req.query.skip or 0
      limit: +req.query.limit or 10
    M.find req.body, null, page, (err, m) ->
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


module.exports = {index, byid, query}
