var express = require('express');
var mysql = require('./dbcon.js');
var bodyParser = require('body-parser');
var app = express();
var handlebars = require('express-handlebars').create({defaultLayout:'main'});

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.use('/static', express.static('public'));
app.set('port', 3000);
app.set('mysql', mysql);


app.use('/gardeners', require('./gardeners.js'));
app.use('/sites', require('./sites.js'));
app.use('/accesses', require('./accesses.js'));
app.use('/workshifts', require('./workshifts.js'));


// Index Page handler
app.get('/',function(req,res){
  var context = {};
  context.pageTitle = "📑 Index"; //other option🌿
  res.render('index1', context);
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
