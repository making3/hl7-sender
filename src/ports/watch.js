'use strict';
/* global document */
const Elm = require('./elm.js');
const settings = require('./src/ports/settings');
const connection = require('./src/ports/connection');
const ipc = require('electron').ipcRenderer;

const container = document.getElementById('container');

const app = Elm.Main.embed(container);

connection.watchForEvents(app);
settings.watchForEvents(app);

ipc.on('menu-click', (s, menuItem) => {
    app.ports.menuClick.send(menuItem);
});
