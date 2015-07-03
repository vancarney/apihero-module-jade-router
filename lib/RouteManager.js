// Generated by CoffeeScript 1.9.0
var EventEmitter, RouteItem, RouteManager, fs, path, _,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __hasProp = {}.hasOwnProperty;

fs = require('fs-extra');

_ = require('lodash')._;

path = require('path');

RouteItem = require('./RouteItem');

EventEmitter = require('events').EventEmitter;

RouteManager = (function(_super) {
  'use strict';
  __extends(RouteManager, _super);

  RouteManager.prototype.routes = [];

  function RouteManager() {
    fs.ensureDir('./views', (function(_this) {
      return function() {
        return fs.ensureDir('./routes', function() {
          return _this.load(function(e) {
            var done;
            if (e != null) {
              return;
            }
            done = _.after(_this.routes.length, function() {
              return _this.emit('initialized', _this.routes);
            });
            return _.each(_this.routes, function(route) {
              return _this.createRoute(route, done);
            });
          });
        });
      };
    })(this));
  }

  RouteManager.prototype.getRoute = function(route) {
    return _.where(this.routes, {
      route_file: route
    });
  };

  RouteManager.prototype.createRoute = function(routing, callback) {
    return (new RouteItem(routing)).save(callback);
  };

  RouteManager.prototype.destroyRoute = function(route, callback) {};

  RouteManager.prototype.listRoutes = function() {
    return this.routes;
  };

  RouteManager.prototype.load = function(callback) {
    var e;
    try {
      this.routes = this.getpaths('./views');
    } catch (_error) {
      e = _error;
      return typeof callback === "function" ? callback(e) : void 0;
    }
    return typeof callback === "function" ? callback(null, this.routes) : void 0;
  };

  RouteManager.prototype.formatRoute = function(path) {
    return path.replace(/index/, '/').replace(/^(\/?[a-zA-Z0-9_]{1,}\/+)+(edit|index|show)$/, "$1:id/$2").replace(/\/\//, '/').replace(/^([a-zA-Z0-9_])+\/+$/, '$1');
  };

  RouteManager.prototype.getpaths = function(dir) {
    var e, file, itemName, list, name, paths, routeItem, stat, _i, _len;
    paths = [];
    if ((list = fs.readdirSync(dir)).length) {
      for (_i = 0, _len = list.length; _i < _len; _i++) {
        name = list[_i];
        if ((name.match(/^\./)) != null) {
          continue;
        }
        file = path.join(dir, name);
        try {
          stat = fs.statSync(file);
        } catch (_error) {
          e = _error;
          throw new Error(e);
          return false;
        }
        if (stat != null ? stat.isDirectory() : void 0) {
          paths.push(this.getpaths("./" + file));
        } else {
          itemName = name.split('.')[0];
          if ((name.match(/^[^_]+[a-zA-Z0-9_\.]+\.jade+$/)) == null) {
            continue;
          }
          routeItem = {
            name: itemName,
            file_type: 'jade',
            query_method: itemName === 'index' ? 'find' : 'findOne',
            route_file: "./" + (path.join('routes', dir.replace(/\/?views+/, ''), itemName)),
            template_file: path.join(dir.replace(/\/?views+/, ''), itemName),
            route: this.formatRoute(path.join(dir.replace(/\/?views+/, ''), itemName))
          };
          paths.push(routeItem);
        }
      }
    }
    return _.flatten(paths);
  };

  RouteManager.getInstance = function() {
    return this.__instance != null ? this.__instance : this.__instance = new this;
  };

  return RouteManager;

})(EventEmitter);

module.exports = RouteManager;