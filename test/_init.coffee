{_}             = require 'lodash'
fs              = require 'fs'
path            = require 'path'
{should,expect} = require 'chai'
global._        = _
global.should   = should
global.expect   = expect
global.app_root = path.join __dirname, 'server'

lt        = require 'loopback-testing'
server    = require './server/server/server'

describe 'init app', ->
  @timeout 10000
  it 'should emit a `ready` event', (done)=>
    server.once 'ahero-ready', =>
      global.app = server
      expect(app.ApiHero).to.exist
      # global.api_options  = require '../lib/classes/config/APIOptions'
      done.apply @, arguments
      
    
  it 'should have created index route', (done)=>
    setTimeout (=>
      fs.stat "#{app_root}/routes/index.js", done
    ), 1200
    
  it 'should create a new Route when a View is created', (done)=>
    fs.writeFile "#{app_root}/views/testing.jade", 'h1 Test', =>
      setTimeout (=>
        fs.stat "#{app_root}/routes/testing.js", done
      ), 2500

  it 'should remove a route when view is removed', (done)=>
    fs.unlinkSync "#{app_root}/views/testing.jade"
    
    setTimeout (=>
      fs.stat "#{app_root}/routes/testing.js", (e)=>
        expect(e).to.exist
        done()
        
    ), 2500
           
  after (done)=>
    fs.unlink "#{app_root}/routes/index.js", =>
      fs.unlink "#{app_root}/routes/testing.js", => done()
    fs.unlink "#{app_root}/routes/index.json", =>
      fs.unlink "#{app_root}/routes/testing.json", => done()
