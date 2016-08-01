{_}             = require 'lodash'
fs              = require 'fs'
path            = require 'path'
{should,expect} = require 'chai'
global._        = _
global.should   = should
global.expect   = expect
global.app_root = __dirname
should()

router = require '../src/apihero-module-pug-router'

describe 'Pug Router Test Suite', ->
  it 'should initialize', (done)=>
    router.init app, {}, (e, res)->
      console.log "initialized"
      console.log arguments
      done()    