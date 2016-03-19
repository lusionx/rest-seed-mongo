_       = require 'lodash'


utils   = require '../../lib/utils'


model = (v='Model', col='col') ->
  (req, res, next) ->
    name = _.get(req.params, col) or _.get(req.hooks, col)
    M = req.hooks[v] = utils.model name
    return next() if M
    res.json 400, {code: 'ResourceNotFound', message: "Collection(#{name})NotExists"}
    next no


byid = (model = 'Model', id='id', ref='') ->
  (req, res, next) ->
    M = req.hooks[model]
    v = _.get(req.params, id) or _.get(req.hooks, id)
    M.findById v, (err, m) ->
      return next err if err
      if ref
        req.hooks[ref] = m
      else
        res.json m
      next()

send = (ref) ->
  (req, res, next) ->
    res.json req.hooks[ref]
    next()



module.exports = {model, byid, send}
