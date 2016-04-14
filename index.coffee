_           = require 'lodash'

config = require './configs'
console.log config

log4js = require 'log4js'
log4js.configure
  appenders: [
      type: 'console'
      category: 'default'
  ]


mongoose = require 'mongoose'

_.each config.plugins, (v, k) ->
  name = if _.isString v then v else k
  opt = v if _.isString k
  try
    p = require name
    mongoose.plugin p, opt
  catch
    throw new Error 'cant load plugin: ' + name

mongoose.set 'debug', yes
mongoose.connect config.db
db = mongoose.connection
db.on 'error', (err) ->
  console.error err

initModel = (ls) ->
  cond = (e) ->
    return yes if e in config.models
    return no if '-' + e in config.models
    yes
  _.each ls, (name) ->
    return if not cond name
    m = new mongoose.Schema {},
      strict: no
      id: no
    mongoose.model name, m, name
    console.log 'init', name

db.once 'open', () ->
  console.error 'mongoose open'
  db = mongoose.connection.db
  db.listCollections().toArray (err, ls) ->
    throw err if err
    names = _.map ls, (e) -> e.name
    n2 = _.filter config.models, (e) -> e[0] isnt '-'
    names = _.flatten [names, n2]
    initModel _.uniq names



rest = require 'rest-seed'
rest __dirname
