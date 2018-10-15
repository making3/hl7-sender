/* global document */
const Elm = require('../../dist/elm.js');
import { ipcRenderer}  from 'electron';
import * as settings from './settings';
import * as connection from './connection';
import { App } from './types';

const container = document.getElementById('container');

const app: App = Elm.Main.embed(container);

connection.watchForEvents(app);
settings.watchForEvents(app);

ipcRenderer.on('menu-click', (_, menuItem) => {
  app.ports.menuClick.send(menuItem);
});