'use strict';
const fs = require('fs');
const path = require('path');
const electron = require('electron');

exports.getUserData = getUserData;
function getUserData (userDataFile, defaultContent, callback) {
    const fileName = getUserDataFileName(userDataFile);
    if (!fs.existsSync(fileName)) {
        return saveDefaultUserData(userDataFile, defaultContent, callback);
    }

    fs.readFile(fileName, 'utf8', (error, fileJson) => {
        if (error) {
            return callback(error);
        }
        if (!fileJson) {
            return saveDefaultUserData(userDataFile, defaultContent, callback);
        }
        callback(error, fileJson);
    });
};

exports.getUserDataObject = (userDataFile, defaultContent, callback) => {
    // userData.getUserDataObject(userDataFileName, {}, callback);
    defaultContent = JSON.stringify(defaultContent);
    getUserData(userDataFile, defaultContent, (error, userDataJson) => {
        if (error) {
            return callback(error);
        }

        const userData = JSON.parse(userDataJson)
        callback(null, userData);
    });
};

function getUserDataFileName(userDataFile) {
    return path.join(
        (electron.app || electron.remote.app).getPath('userData'),
        userDataFile
    );
}

function saveDefaultUserData(userDataFile, defaultUserData, callback) {
    saveUserData(userDataFile, defaultUserData, (error) => {
        callback(error, defaultUserData);
    });
}

exports.saveUserData = saveUserData;
function saveUserData(userDataFile, userData, callback) {
    const fileName = getUserDataFileName(userDataFile);

    fs.writeFile(fileName, userData, 'utf8', callback);
}

exports.formatJson = (json) => {
    if (json === 'string') {
        json = JSON.parse(json);
    }
    return JSON.stringify(json, null, 2);
};
