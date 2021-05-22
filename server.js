// REQUIRED MODULES

// local config
require('dotenv').config()

// connect to database
const mongoose = require('mongoose');

// web server framework...
const express = require("express");

// ... with template engine layout 
const expressLayouts = require("express-ejs-layouts");

// snmp requests
//const snmp = require("net-snmp");

// file system to write files
//const fs = require("fs");

// ROUTES require
//const indexRouter = require("./routes/index");
const descriptionRouter = require("./routes/descriptions");

// Create the app and setting up the environment
const app = express();

// template engine
app.set("view engine", "ejs");
app.set("views", __dirname + "/views");
app.set("layout", "layouts/layout");
app.use(expressLayouts);

// not bodyparser anymore
app.use(express.json());
app.use(express.urlencoded({
  extended: true
}));

// This is for hosting files
app.use(express.static(`${__dirname}/public`));

// routes
//app.use('/', indexRouter);
app.use('/descriptions', descriptionRouter);

// Set up the server
// This call back just tells us that the server has started
const listen = () => {
  const host = server.address().address;
  const port = server.address().port;
  console.log(
    `Lac server listening at http://${host}:${port}`
  );
};
// process.env.PORT is related to deploying on heroku
const server = app.listen(process.env.PORT || 3000, listen);

// MONGO DB CONNECTION
mongoose.connect(process.env.DATABASE_URL, { useNewUrlParser: true, useUnifiedTopology: true });
const db = mongoose.connection;
db.on ('error', error => console.error(error));
db.once ('open', () => console.log('Connected to MongoDB'));

app.get('/', (req, res) => {
  res.render('index'), {
      mongoMessage: mongoMesssage
  };
})