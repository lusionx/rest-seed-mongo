_     = require 'lodash'
utils = require '../lib/utils'


modules = {}
for file in utils.readdir(__dirname, ['coffee', 'js'], ['index', 'defaults'])
  moduleName = utils.file2Module file
  modules[moduleName] = require "./#{file}"


module.exports = (ose) ->
  _.each modules, (fn, name) ->
    m = fn ose.Schema
    ose.model name, m, name


