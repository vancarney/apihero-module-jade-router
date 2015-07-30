fs      = require 'fs'
path    = require 'path'
_       = require 'lodash'
jade    = require 'apihero-module-jade'
modRewrite = require 'connect-modrewrite'

module.exports.jade = {}
_.each jade, (fun,param)=>
  module.exports.jade[param] = fun

_defaults = {
  viewsPath:  path.join "#{app_root || process.cwd()}", 'views'
  routesPath: path.join "#{app_root || process.cwd()}", 'routes'
  helpersPath: path.join "#{app_root || process.cwd()}", 'helpers'
}

initXHR:->
  app.use (req, res, next)->
    unless typeof res.locals? is 'object'
      res.locals = {};
      res.locals.isXHR = (req.headers.hasOwnProperty('x-requested-with') && req.headers['x-requested-with'] is 'XMLHttpRequest')
      next()

loadHelpers = (callback)->
  handleFile = (path, cB)->
    fs.stat path, (e, stat)=>
      if (stat.isFile())
        try
          r = require path
        catch e
          return console.log e
        _.extend helpers, r
        cB? null
       else
        cB? null
  fs.readdir @options.helpersPath, (e,files)=>
    done = _.after files.length, => callback null
    _.each files, (file)=> handleFile path.join( app_root, 'helpers', file ), done
    
module.exports.init = (app, options, callback)->
  @options = _.extend _defaults, options
  views = [@options.viewsPath]
  rules_path = path.join @options.routesPath, 'rewrite-rules.json'
  _routes = []
  app.once 'ahero-modules-loaded', =>
    loadedModules = [].concat app.ApiHero.loadedModules
    loadedModules.splice idx, 1 if 0 <= (idx = loadedModules.indexOf path.basename module.id, '.js')
    done = _.after loadedModules.length, =>
      app.set 'view engine', 'jade'
      app.set 'views', views
      try
        rules = require rules_path
      catch e
        console.log e
        fs.writeFileSync rules_path, '[]'
        rules = []
      app.use modRewrite rules
      # console.log "views: #{views}"
      callback null, views
    _routeManager = RouteManager.getInstance().on 'initialized', (routes)=>
      _routes = routes
      generateRoute = (route)=>
        _routeManager.createRoute route, (e)=>
          return console.log e if e? and e.code != 'EEXIST'
          setTimeout (=>
            (require "#{route.route_file}").init app
            done()
          ), 1300
      _.each routes, (route)=>
        generateRoute route
      app.ApiHero.createSyncInstance 'route', RoutesMonitor
      .addSyncHandler 'route', 'added', (op)=>
        _routeManager.load (e,r)=>
          generateRoute route[0] if (route = _.where r, route_file:op.name)?.length
      .addSyncHandler 'route', 'removed', (op)=>
        fs.unlink "#{op.name}.js", (e)=>
          console.log e if e?
    # call done if no modules need loading
    done()

RouteManager  = require './RouteManager'
RoutesMonitor = require './RoutesMonitor'