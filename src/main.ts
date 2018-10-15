'use strict';
import { join } from 'path';
import { app, Menu, BrowserWindow } from 'electron';
import { watch } from 'chokidar';
import * as contextMenu from 'electron-context-menu';

const debug = process.argv.indexOf('--debug') > -1 || process.argv.indexOf('-d') > -1;

let mainWindow;

app.on('ready', createWindow);

if (debug) {
  const watchers = [
    'index.html',
    'elm.js',
    './css/application.css',
    './src/**/*.js'
  ];

  watch(watchers).on('change', () => {
    if (mainWindow) {
      mainWindow.reload();
    }
  });
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: debug ? 1024 : 768,
    height: debug ? 768 : 512
  });

  const indexPath = join(__dirname, '..', 'index.html');
  mainWindow.loadURL(`file://${indexPath}`);

  if (debug) {
    mainWindow.webContents.openDevTools();
  }

  const menu = getMenu();
  Menu.setApplicationMenu(menu);

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
  contextMenu({ showInspectElement: true });
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

function getMenu() {
  const menuTemplate: Electron.MenuItemConstructorOptions[] = [
    {
      label: 'HL7 Sender',
      submenu: [
        {
          label: 'About',
          click: () => {
            mainWindow.webContents.send('menu-click', 'about');
          }
        },
        {
          type: 'separator'
        },
        {
          label: 'Quit',
          click: () => {
            app.quit();
          }
        }
      ]
    },
    {
      label: 'Settings',
      submenu: [
        {
          label: 'Control Characters',
          click: () => {
            mainWindow.webContents.send('menu-click', 'edit-control-characters');
          }
        }
      ]
    }
  ];

  return Menu.buildFromTemplate(menuTemplate);
}
