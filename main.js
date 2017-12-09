'use strict';
const electron = require('electron');
const chokidar = require('chokidar');

const app = electron.app;
const Menu = electron.Menu;
const BrowserWindow = electron.BrowserWindow;

let mainWindow;

app.on('ready', createWindow);

const watchers = [
    'index.html',
    'elm.js',
    './css/application.css',
    './src/ports/watch.js',
    './src/ports/settings.js',
    './src/ports/connection.js'
];

chokidar.watch(watchers).on('change', () => {
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

    const menu = getMenu(app);
    Menu.setApplicationMenu(menu);

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

function getMenu() {
    const menuTemplate = [
        {
            label: 'HL7 Sender',
            submenu: [
                {
                    label: 'About',
                    click: () => {
                        // TODO: Add an about page.
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

require('electron-context-menu')({
    showInspectElement: true
});
