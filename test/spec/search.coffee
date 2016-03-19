_       = require 'lodash'
should  = require 'should'
async   = require 'async'
root    = require '../root'

logger  = root.logger

rows = null
row = null

describe 'search', () ->
  it 'create list', (done) ->
    iter = (i, fin) ->
      par =
        uri: '/foo/_create'
        method: 'POST'
        json:
          id: i + ''
          name: i + 'ixx' + i
      root.request par, (err, resp, body) ->
        resp.statusCode.should.be.eql 201
        fin err, body
    async.map _.range(18), iter, (err, ls) ->
      rows = ls
      done()

  it 'list size', (done) ->
    par =
      uri: '/foo/_search'
      qs:
        limit: 9
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.eql 200
      body.length.should.be.eql par.qs.size or par.qs.limit
      done()

  it 'list fields', (done) ->
    par =
      uri: '/foo/_search'
      qs:
        size: 1
        fields: 'id'
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.eql 200
      body.length.should.be.eql par.qs.size
      f = _.isUndefined body[0].name
      f.should.be.true()
      done()

  it 'list skip 0', (done) ->
    par =
      uri: '/foo/_search'
      qs:
        size: 2
        sort: '+id'
        skip: 1
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.eql 200
      body.length.should.be.eql par.qs.size
      row = body[1]
      done()

  it 'list skip 1', (done) ->
    par =
      uri: '/foo/_search'
      qs:
        size: 1
        sort: '+id'
        from: 2
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.eql 200
      body.length.should.be.eql par.qs.size
      body[0].should.be.eql row
      row = null
      done()


  it 'list query get', (done) ->
    i = '10'
    par =
      uri: '/foo/_search'
      qs:
        q: 'id:' + i
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.eql 200
      body.length.should.be.eql 1
      body[0].id.should.be.eql i
      done()

  it 'list query post', (done) ->
    i = '10'
    par =
      uri: '/foo/_search'
      method: 'POST'
      json: id: i
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.eql 200
      body.length.should.be.eql 1
      body[0].id.should.be.eql i
      done()

  it 'rm list', (done) ->
    iter = (i, fin) ->
      par =
        uri: '/foo/' + i._id
        method: 'DELETE'
      root.request par, (err, resp, body) ->
        resp.statusCode.should.be.eql 204
        fin err
    async.each rows, iter, (err, rows) ->
      done()
