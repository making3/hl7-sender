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
    //
    // app.ports.settingsGet.subscribe(() => {
    //     getSettingsJson((error, settingsJson) => {
    //         app.ports.settings.send(error.toString(), settingsJson);
    //     });
    // });
};

function getSettingsJson(callback) {
    // TODO: If user settings don't exist, create initial ones...
    fs.readFile(settingsFile, 'utf8', callback);
}

function saveSettings(settingsJson, callback) {
    // Pretty print the settings.
    const settingsFormatted = getFormattedSettings(settingsJson);

    fs.writeFile(settingsFile, settingsFormatted, callback);
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
