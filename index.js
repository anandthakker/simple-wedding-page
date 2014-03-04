

var express = require('express')
  , http = require('http')
  , path = require('path')
  , argv = require('optimist').argv;

var app = express();

app.configure(function(){
  app.set('port', 8080);
//  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

if(argv.server)
  http.createServer(app).listen(app.get("port"), function () {
    console.log("Express server listening on port " + app.get("port"));
  });

exports.app = app;
