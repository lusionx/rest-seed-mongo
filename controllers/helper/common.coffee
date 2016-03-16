utils = require '../../lib/utils'
_     = require 'lodash'

logger = utils.getLogger 'default'

common =
  jsonp: (_hooks, origin) -> # 使用jsonp 的方式返回数据
    (req, res, next) ->
      obj = req.hooks[_hooks]
      return next() if not obj
      if method = (req.params.callback or req.params.jsonp)
        res.contentType = 'application/javascript'
        res.end method + '(' + JSON.stringify(obj) + ')'
      else
        res.header 'Access-Control-Allow-Origin', '*' if origin
        res.json obj
      next()

  debug: (_hooks, val) ->
    (req, res, next) ->
      v = req.hooks[_hooks]
      logger.debug v
      logger.debug val if val
      next()

  redirect: (_hooks='redirect') -> # 跳转地址
    (req, res, next) ->
      if uri = req.hooks[_hooks]
        res.header 'Location', uri
        res.send 302, null
      next()

  reqTime: (_hooks='time', fn=null) -> # 中间件 响应时间计时
    (req, res, next) ->
      f = yes
      f = fn req, res if _.isFunction fn
      req.hooks[_hooks] = [{_init: new Date}] if f
      next()

  reqTimeAdd: (key='no', _hooks='time') ->
    (req, res, next) ->
      return next() if not req.hooks[_hooks]
      arr = req.hooks[_hooks]
      a = arr[0]._init
      o = {}
      o[key] = (new Date) - a
      arr.push o
      next()

  reqTimeEnd: (_hooks='time') ->
    (req, res, next) ->
      return next() if not req.hooks[_hooks]
      arr = req.hooks[_hooks]
      o = {}
      _.each arr, (v) ->
        k = _.keys v
        o[k[0]] = v[k[0]]
      o.end = (new Date) - o._init
      delete o._init
      lg = utils.getLogger 'reqTime'
      lg.info '%s %j %j', _hooks, o, req.params
      next()

  # 包装中间件, 以当时的req, res 控制是否运行
  # params fns: function, [function] | (req, res, next) -> 典型中间件
  # params cond: (req, res) -> | 返回bool 确定中间件是否运行
  wrapIf: (fns, cond) ->
    fns = [fns]
    fns = _.flatten fns, yes
    _.map fns, (e) ->
      (req, res, next) ->
        foo = cond req, res
        if foo
          e req, res, next
        else
          next()

module.exports = common
