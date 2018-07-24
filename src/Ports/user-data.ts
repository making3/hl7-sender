import { existsSync, readFile, writeFile } from 'fs';
import * as path from 'path';
import * as electron from 'electron';

export function getUserData(userDataFile, defaultContent, callback) {
  const fileName = getUserDataFileName(userDataFile);
  if (!existsSync(fileName)) {
    return saveDefaultUserData(userDataFile, defaultContent, callback);
  }

  readFile(fileName, 'utf8', (error, fileJson) => {
    if (error) {
      return callback(error);
    }
    if (!fileJson) {
      return saveDefaultUserData(userDataFile, defaultContent, callback);
    }
    callback(error, fileJson);
  });
};

export function getUserDataObject(userDataFile, defaultContent, callback) {
  defaultContent = JSON.stringify(defaultContent);
  getUserData(userDataFile, defaultContent, (error, userDataJson) => {
    if (error) {
      return callback(error);
    }

    const userData = JSON.parse(userDataJson)
    callback(null, userData);
  });
}

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

export function saveUserData(userDataFile, userData, callback) {
  const fileName = getUserDataFileName(userDataFile);

  writeFile(fileName, userData, 'utf8', callback);
}

export function saveUserDataObject(userDataFile, userData, callback) {
  const userDataJson = formatJson(userData);
  saveUserData(userDataFile, userDataJson, callback);
}

export function formatJson(json) {
  if (typeof json === 'string') {
    json = JSON.parse(json);
  }
  return JSON.stringify(json, null, 2);
};
