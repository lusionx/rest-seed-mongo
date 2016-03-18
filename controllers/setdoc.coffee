_       = require 'lodash'
async   = require 'async'

utils   = require '../lib/utils'
helper  = require './helper'

logger  = utils.getLogger 'ctr-setdoc'


create = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  (req, res, next) ->
    M = req.hooks.Model
    M.create req.body, (err, m) ->
      return next err if err
      res.json 201, m
      next()
]

remove = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  (req, res, next) ->
    M = req.hooks.Model
    id = req.params.id
    M.findByIdAndRemove id, (err) ->
      return next err if err
      res.send 204
      next()
]

replace = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  helper.rest.byid 'Model', 'id', 'm'
  helper.assert.exists 'm'
  (req, res, next) ->
    m = req.hooks.m
    ks = []
    _.each req.body, (v, k) ->
      ks.push k
      m.set k, v
    o = m.toJSON()
    _.each o, (v, k) ->
      return if '_' is k[0]
      m.set k, undefined if k not in ks
    q = m.save()
    q.then (mm) ->
      res.json mm
      next()
]

merge = [
  helper.rest.model 'Model'
  helper.assert.exists 'Model'
  helper.rest.byid 'Model', 'id', 'm'
  helper.assert.exists 'm'
  (req, res, next) ->
    m = req.hooks.m
    _.each req.body, (v, k) ->
      m.set k, v
    q = m.save()
    q.then (mm) ->
      res.json mm
      next()
]

module.exports = {create, remove, replace, merge}
