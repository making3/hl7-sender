import { watch } from 'chokidar';
import { app, BrowserWindow, Menu } from 'electron';
// tslint-disable-line
import * as contextMenu from 'electron-context-menu';
import { join } from 'path';

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
    height: debug ? 768 : 512,
    width: debug ? 1024 : 768
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
          click: () => {
            mainWindow.webContents.send('menu-click', 'about');
          },
          label: 'About'
        },
        {
          type: 'separator'
        },
        {
          click: () => {
            app.quit();
          },
          label: 'Quit'
        }
      ]
    },
    {
      label: 'Settings',
      submenu: [
        {
          click: () => {
            mainWindow.webContents.send('menu-click', 'edit-control-characters');
          },
          label: 'Control Characters'
        }
      ]
    }
  ];

  return Menu.buildFromTemplate(menuTemplate);
}
