utils   = require '../lib/utils'
helper  = require './helper'


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
  helper.rest.byid 'Model', 'id', 'm'
  helper.assert.exists 'm'
  (req, res, next) ->
    req.hooks.m.remove (err) ->
      return next err if err
      res.send 204
      next()
]

replace = [
]

module.exports = {create, remove}
