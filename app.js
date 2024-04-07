var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const tl = require('express-tl')

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use('/stylesheets', express.static(path.join(__dirname, '/node_modules/bootstrap/dist/css')));
app.use('/javascripts', express.static(path.join(__dirname, '/node_modules/axios/dist')));
app.use(express.static(path.join(__dirname, 'public')));

app.engine('tl', tl)
app.set('views', './views') // specify the views directory
app.set('view engine', 'tl') // register the template engine

app.use('/', indexRouter);
app.use('/users', usersRouter);

module.exports = app;
