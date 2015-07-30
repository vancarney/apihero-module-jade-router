var hero = require('api-hero');
var path = require('path');
module.exports = function(app) {
	// global.app_root = path.join(__dirname, '..', '..');
	console.log("global.app_root: "+global.app_root);
	hero.init(app);
};
