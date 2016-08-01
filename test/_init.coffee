{_}             = require 'lodash'
fs              = require 'fs'
path            = require 'path'
EventEmitter    = require 'events'
{should,expect} = require 'chai'
global._        = _
global.should   = should
global.expect   = expect
global.app_root = __dirname
should()

class MockApp extends EventEmitter
  listModules: ->
    []
  getModuleConfigs: ->
      confog =
        setting: 'blah'

global.app =
  get: ->
  set: ->
  use: ->
  engine: ->
  once: (name, callback)->
    callback()
  ApiHero: new MockApp
