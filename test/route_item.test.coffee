{_}             = require 'lodash'
fs              = require 'fs'
path            = require 'path'
{should,expect} = require 'chai'
global._        = _
global.should   = should
global.expect   = expect
global.app_root = __dirname
should()

RouteItem = require '../src/RouteItem'

describe 'Pug Router Test Suite', ->
  it 'should create', =>
    @routeItem = RouteItem.create 'testing', "#{__dirname}/routes/testing"
    @routeItem.should.be.a.object
    @routeItem.save.should.be.a.function

  it 'should save', (done)=>
    @routeItem.save =>
      stat = fs.statSync "#{__dirname}/routes/testing.js"
      stat.isFile().should.be.true
      stat = fs.statSync "#{__dirname}/routes/testing.json"
      stat.isFile().should.be.true
      done()

