import { saveUserDataObject, getUserData,  } from './user-data';
import * as packageJson from '../../package.json';

const userDataFileName = 'settings.json';

export function watchForEvents(app) {
  app.ports.settingsSave.subscribe((settingsJson) => {
    saveSettings(settingsJson, (error) => {
      app.ports.settingsSaved.send(error ? error.toString() : '');
    });
  });

  app.ports.settingsGet.subscribe((defaultSettingsJson) => {
    getUserData(userDataFileName, defaultSettingsJson, (error, settingsJson) => {
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
    app.ports.version.send((packageJson as any).version);
  });
};

function saveSettings(settingsJson, callback) {
  saveUserDataObject(userDataFileName, settingsJson, callback);
}
