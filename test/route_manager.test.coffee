path = require 'path'
RouteManager  = require '../src/RouteManager'

describe 'Pug RouteManager Test Suite', ->
  @routeMan = new RouteManager
  it 'should ', =>
    console.log path.join __dirname, 'routes'
    console.log @routeMan.getpaths path.join __dirname, 'routes'
    
