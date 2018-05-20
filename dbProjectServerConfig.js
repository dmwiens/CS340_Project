var express = require('express');

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout:'main'});
var bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', 3000);
app.use(express.static('public'));


// Page handlers
app.get('/',function(req,res){
  var context = {};
  context.pageTitle = "Mexico 2018";
  res.render('pageMain', context);
});

app.get('/gardeners',function(req,res){
  var context = {};
  context.pageTitle = "👨‍🌾 Gardeners";
  res.render('gardeners', context);
});

app.get('/sites',function(req,res){
  var context = {};
  context.pageTitle = "🌐 Sites";
  res.render('sites', context);
});

app.get('/accesses',function(req,res){
  var context = {};
  context.pageTitle = "Tulum, Quintana Roo";
  res.render('accesses', context);
});


app.get('/f1AboutThisSite',function(req,res){
  var context = {};
  context.pageTitle = "About this Site";
  res.render('f1AboutThisSite', context);
});

app.get('/f2Credits',function(req,res){
  var context = {};
  context.pageTitle = "Credits";
  res.render('f2Credits', context);
});

app.use(function(req,res){
  res.status(404);
  res.render('404');
});

app.use(function(err, req, res, next){
  console.error(err.stack);
  res.type('plain/text');
  res.status(500);
  res.render('500');
});

app.listen(app.get('port'), function(){
  console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});
