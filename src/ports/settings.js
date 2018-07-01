'use strict';
const userData = require('./user-data');
const packageJson = require('../../package');

const userDataFileName = 'settings.json';

exports.watchForEvents = (app) => {
    app.ports.settingsSave.subscribe((settingsJson) => {
        saveSettings(settingsJson, (error) => {
            app.ports.settingsSaved.send(error ? error.toString() : '');
        });
    });

    app.ports.settingsGet.subscribe((defaultSettingsJson) => {
        userData.getUserData(userDataFileName, defaultSettingsJson, (error, settingsJson) => {
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

function saveSettings(settingsJson, callback) {
    userData.saveUserDataObject(userDataFileName, settingsJson, callback);
}
