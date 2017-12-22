'use strict';
const fs          = require('fs');
const path        = require('path');
const electron    = require('electron');
const packageJson = require('../../package');

let settingsFile;
exports.watchForEvents = (app) => {
    settingsFile = path.join(
        (electron.app || electron.remote.app).getPath('userData'),
        'settings.json'
    );

    app.ports.settingsSave.subscribe((settingsJson) => {
        saveSettings(settingsJson, (error) => {
            app.ports.settingsSaved.send(error ? error.toString() : '');
        });
    });

    app.ports.settingsGet.subscribe((defaultSettingsJson) => {
        getSettingsJson(defaultSettingsJson, (error, settingsJson) => {
            if (error) {
                error = error.toString();
            }
            app.ports.settings.send([
                error ? error.toString() : '',
                settingsJson
            ]);
        });
    });

    app.ports.versionGet.subscribe(() => {
        app.ports.version.send(packageJson.version);
    });
};

function getSettingsJson(defaultSettingsJson, callback) {
    if (!fs.existsSync(settingsFile)) {
        return saveDefaultSettings(defaultSettingsJson, callback);
    }

    fs.readFile(settingsFile, 'utf8', (error, settingsJson) => {
        if (error) {
            return callback(error);
        }
        if (!settingsJson) {
            return saveDefaultSettings(defaultSettingsJson, callback);
        }
        callback(error, settingsJson);
    });
}

function saveDefaultSettings(defaultSettingsJson, callback) {
    saveSettings(defaultSettingsJson, (error) => {
        callback(error, defaultSettingsJson);
    });
}

function saveSettings(settingsJson, callback) {
    // Pretty print the settings
    const settingsFormatted = getFormattedSettings(settingsJson);

    fs.writeFile(settingsFile, settingsFormatted, 'utf8', callback);
}

function getFormattedSettings(settingsJson) {
    return JSON.stringify(JSON.parse(settingsJson), null, 4);
}
