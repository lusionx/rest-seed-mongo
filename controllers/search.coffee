_       = require 'lodash'
async   = require 'async'

utils   = require '../lib/utils'
helper  = require './helper'

logger  = utils.getLogger 'ctr-search'

Page = (req) ->
  page =
    skip: +req.query.skip or +req.query.form or 0
    limit: +req.query.limit or +req.query.size or 10
  if page.limit < 0 or page.limit > 1000
    page.limit = 1000
  page

Fields = (req) ->
  fields = null
  f = req.query.fields
  if f and f.length > 0
    fields = f
  fields


index = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  (req, res, next) ->
    M = req.hooks.Model
    query = {}
    v = req.query.q
    if v and m = /^(.+?):(.+?)$/.exec v
      query[m[1]] = m[2]
    M.find query, Fields(req), Page(req), (err, m) ->
      return next err if err
      res.json m
      next()
]

query = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  (req, res, next) ->
    M = req.hooks.Model
    M.find req.body, Fields(req), Page(req), (err, m) ->
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
