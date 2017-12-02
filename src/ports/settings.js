'use strict';
const fs   = require('fs');
const path = require('path');
const electron = require('electron');

let settingsFile;
exports.watchForEvents = (app) => {
    settingsFile = path.join(
        (electron.app || electron.remote.app).getPath('userData'),
        'settings.json'
    );

    // app.ports.settingsSave.subscribe((settingsJson) => {
    //     console.log('settingsJson: ', settingsJson);
    //     saveSettings(settingsJson, (error) => {
    //         app.ports.settingsSaved.send(error.toString());
    //     });
    // });

    app.ports.settingsGet.subscribe((defaultSettingsJson) => {
        getSettingsJson(defaultSettingsJson, (error, settingsJson) => {
            app.ports.settings.send(error.toString(), settingsJson);
        });
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
    // Pretty print the settings.
    const settingsFormatted = getFormattedSettings(settingsJson);

    fs.writeFile(settingsFile, settingsFormatted, 'utf8', callback);
}

function getFormattedSettings(settingsJson) {
    return JSON.stringify(JSON.parse(settingsJson), null, 4);
}

/*
    SUBS:
    settingsSaved(string errorMessage)
    settings(string error, string jsonSettings)

    Commands:
    settingsGet()
    settingsSave(string jsonSettings)
*/
