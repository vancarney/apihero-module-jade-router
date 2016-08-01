fs  = require 'fs-extra'
{_} = require 'lodash'
_path = require 'path'
RouteItem = require './RouteItem'
{EventEmitter} = require 'events'
class RouteManager extends EventEmitter
  'use strict'
  routes:[]
  _viewsDir: _path.join "#{app_root || '.'}", 'views'
  _routesDir: _path.join "#{app_root || '.'}", 'routes'
  constructor:->
    fs.ensureDir @_viewsDir, =>
      fs.ensureDir @_routesDir, =>
        @load (e, routes)=>
          return if e?
          @routes = routes
          @emit 'initialized', @routes
  getRoute:(route)->
    _.where @routes, route_file: route
  createRoute:(routing, callback)->
    (new RouteItem routing).save => 
      callback?.apply @, arguments
  destroyRoute:(route, callback)->
    # todo: implement this
  listRoutes:->
    @routes
  load:(callback)->
    try
      _routes = @getpaths @_viewsDir
    catch e
      return callback? e
    # console.log _routes
    callback? null, _routes
  getpaths:(dir)->
    paths = []
    if (list = fs.readdirSync dir).length
      for name in list
        continue if (name.match /^\./)?
        console.log "dir: #{dir}"
        file = _path.join dir, name
        try
          # attempt to get stats on the file
          stat = fs.statSync file
        catch e
          throw new Error e
          return false
        if stat?.isDirectory()
          # skips folders prepended with `_`
          continue if _path.basename(file).match /^_+/
          # # walks this directory and adds results to array
          paths.push @getpaths file
        else
          itemName = name.split('.')[0]
          # we only handle Jade files
          continue unless (name.match /^[^_]+[a-zA-Z0-9_\.]+\.(pug|jade)+$/)?
          p = new RegExp @_viewsDir.replace( /\//,'\/')
          routeItem = new RouteItem

          routeItem.route_file = "./#{routeItem.route_file}" unless routeItem.route_file.match /^\.?\/+/
          paths.push routeItem
    _.flatten paths
  @getInstance: ->
    @__instance ?= new @  
module.exports = RouteManager