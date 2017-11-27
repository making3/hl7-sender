'use strict';
const electron = require('electron');
const chokidar = require('chokidar');

const app = electron.app;
const BrowserWindow = electron.BrowserWindow;

let mainWindow;

app.on('ready', createWindow);

chokidar.watch([ 'ports.js', 'index.html', 'elm.js', './lib/connection.js' ]).on('change', () => {
  if (mainWindow) {
    mainWindow.reload();
  }
});

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1024,
    height: 768
  });

  mainWindow.loadURL(`file://${ __dirname }/index.html`);

  mainWindow.webContents.openDevTools();

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (mainWindow === null) {
    createWindow();
  }
});
