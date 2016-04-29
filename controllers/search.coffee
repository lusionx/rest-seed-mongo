_       = require 'lodash'
async   = require 'async'

utils   = require '../lib/utils'
config  = require '../configs'
helper  = require './helper'

logger  = utils.getLogger 'ctr-search'

Page = (req) ->
  q = req.query
  page =
    skip: +q.skip or +q.from or 0
    limit: +q.limit or +q.size or config.search.LIMIT
  if page.limit < 0
    page.limit = config.search.LIMIT
  if page.limit > config.search.LIMIT_MAX
    page.limit = config.search.LIMIT_MAX
  if s = q.sort
    page.sort = {}
    if m = /^([+\-]{1})([a-zA-z0-9\.]+$)/.exec s
      page.sort[m[2]] = if m[1] is '+' then 1 else -1
    else if m = /^([+\-]{1})([a-zA-z0-9\.]+)([+\-]{1})([a-zA-z0-9\.]+$)/.exec s
      page.sort[m[2]] = if m[1] is '+' then 1 else -1
      page.sort[m[4]] = if m[3] is '+' then 1 else -1
    else
      delete page.sort
  page

Fields = (req) ->
  fields = null
  f = req.query.fields
  if f and f.length > 0
    fields = f
  fields

HEAD_TOTAL = 'X-Content-Total'

_convVal = (v) ->
  if v in ['__y', '__yes', '__t', '__true']
    vv = yes
  else if v in ['__n', '__no', '__f', '__false']
    vv = no
  else if m = /^__(\d+)$/.exec v
    vv = +m[1]
  else
    vv = v
  vv

_convRec = (e) ->
  logger.debug e
  _.each e, (v, k) ->
    logger.debug k, v
    if _.isString v
      logger.debug e[k] = _convVal v
    else
      _convRec v


index = [
  helper.rest.model 'Model'
  (req, res, next) ->
    M = req.hooks.Model
    query = req.query.q or {}
    _convRec query
    M.count query, (err, c) ->
      res.header HEAD_TOTAL, c
      return next err if err
      return res.json([]) and next() if c is 0
      M.find query, Fields(req), Page(req), (err, m) ->
        return next err if err
        res.json m
        next()
]

query = [
  helper.rest.model 'Model'
  (req, res, next) ->
    M = req.hooks.Model
    M.count query, (err, c) ->
      res.header HEAD_TOTAL, c
      return next err if err
      return res.json([]) and next() if c is 0
      M.find req.body, Fields(req), Page(req), (err, m) ->
        return next err if err
        res.json m
        next()
]

byid = [
  helper.rest.model 'Model'
  helper.rest.byid 'Model', 'id', 'm'
  helper.assert.exists 'm'
  helper.rest.send 'm'
]


module.exports = {index, byid, query}
