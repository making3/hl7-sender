'use strict';
/* global document */
const Elm        = require('./elm.js');
const connection = require('./lib/connection');

const container = document.getElementById('container');

const app = Elm.Main.embed(container);

connection.watchForEvents(app);
