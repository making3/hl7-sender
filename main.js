'use strict';
const electron    = require('electron');
const chokidar    = require('chokidar');
const contextMenu = require('electron-context-menu');

const app = electron.app;
const Menu = electron.Menu;
const BrowserWindow = electron.BrowserWindow;

let debug = process.argv.indexOf('--debug') > -1 ||
    process.argv.indexOf('-d') > -1;

let mainWindow;

app.on('ready', createWindow);

if (debug) {
    const watchers = [
        'index.html',
        'elm.js',
        './css/application.css',
        './src/**/*.js'
    ];

    chokidar.watch(watchers).on('change', () => {
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

    mainWindow.loadURL(`file://${ __dirname }/index.html`);

    if (debug) {
        mainWindow.webContents.openDevTools();
    }

    const menu = getMenu(app);
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
    const menuTemplate = [
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

    const menu = Menu.buildFromTemplate(menuTemplate);
    return menu;
}
