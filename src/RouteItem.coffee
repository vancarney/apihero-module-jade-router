fs = require 'fs-extra'
path = require 'path'
{_} = require 'lodash'
class RouteItem
  constructor:(@route_item)->
  save:(callback)->
    throw 'callback required' unless callback? and typeof callback is 'function'
    fs.ensureDir path.dirname( p = @route_item.route_file ), (e)=>
      return callback.apply @, arguments if e?
      fs.writeFile "#{p}.js", @template(@route_item), {flag:'wx+'}, (e)=>
        callback.apply @, arguments if e?
        fs.writeFile "#{p}.json", JSON.stringify(@route_item, null, 2), {flag:'wx+'}, (e)=>
          callback.apply @, arguments
RouteItem::template = _.template """
/**
 * <%= name %>.js
 * Route Handler File
 * Generated by Jade-Router for ApiHero 
 */
var _app_ref;
var config = require('./<%= name %>.json');
var render = function(res, model) {
  res.render( config.template_file, model, function(e,html) {
    if (e !== null) console.log(e);
    res.send(html);
  }); 
};

var <%= name %>Handler = function(req, res, next) {
  var funcName = config.queryMethod || 'find';
  var collectionName = ((name = config.collectionName) == "") ? null : name;
  var model = {meta:[], results:[]};
  
  if (collectionName == null && _app_ref.models.hasOwnProperty(collectionName) == false )
    return render(res, model);
  
  _app_ref.models[collectionName][funcName]( config.query, function(e,record) {
    if (e != null) {
      console.log(e);
      return res.sendStatus(500);
    }
    
    model.results = results;
    render(res,record);
  });
};

module.exports.init = function(app) {
  _app_ref = app;
  app.get(config.route, <%= name %>Handler);
};
"""
module.exports = RouteItem