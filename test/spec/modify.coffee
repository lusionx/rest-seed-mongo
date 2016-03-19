_       = require 'lodash'
should  = require 'should'
root    = require '../root'

logger  = root.logger

row = null

doc1 = null


describe 'modify', () ->
  it 'new', (done) ->
    par =
      uri: '/foo/_create'
      method: 'POST'
      json:
        id: 123456
        name: 'name'
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.equal 201
      row = body
      done()

  it 'get one', (done) ->
    par =
      uri: '/foo/' + row._id
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.equal 200
      row.should.be.deepEqual body
      done()

  it 'put ', (done) ->
    doc =
      id: _.random 1000000
      name: 'name2'
    par =
      uri: '/foo/' + row._id
      method: 'PUT'
      json: doc
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.equal 200
      done()

  it 'merge', (done) ->
    doc =
      tags: ['a', 'b']
    par =
      uri: '/foo/' + row._id
      method: 'PATCH'
      json: doc
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.equal 200
      done()


  it 'remove', (done) ->
    par =
      uri: '/foo/' + row._id
      method: 'DELETE'
    root.request par, (err, resp, body) ->
      resp.statusCode.should.be.equal 204
      done()
