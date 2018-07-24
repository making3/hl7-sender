import { Socket } from 'net';
import { getUserData, getUserDataObject, saveUserDataObject } from './user-data';

let client;
const userDataFileName = 'connections.json';

export function watchForEvents(app) {
  app.ports.connect.subscribe(([ ip, port ]) => {
    client = connect(app, ip, port);
  });

  app.ports.disconnect.subscribe(() => {
    disconnect();
  });

  app.ports.send.subscribe((hl7) => {
    send(hl7, () => {
      app.ports.sent.send(null);
    });
  });

  app.ports.getConnections.subscribe((defaultConnectionsJson) => {
    getUserData(userDataFileName, defaultConnectionsJson, (error, connectionsJson) => {
      app.ports.initialSavedConnections.send([
        error ? error.toString() : '',
        connectionsJson
      ]);
    });
  });

  app.ports.saveConnection.subscribe((newConnectionJson) => {
    const newConnection = JSON.parse(newConnectionJson);
      saveConnection(newConnection.name, newConnection.destinationIp, newConnection.destinationPort, (error, isNewConnection) => {
        const errorMessage = error ? error.toString() : '';
        if (isNewConnection) {
          app.ports.savedNewConnection.send(errorMessage);
        } else {
          app.ports.savedConnection.send(errorMessage);
        }
      });
  });
};

function connect(app, ip, port) {
  client = new Socket();

  client.connect(port, ip, () => {
    app.ports.connected.send(null);
  });

  client.on('error', (error) => {
    app.ports.connectionError.send(error.toString());
  });

  client.on('close', () => {
    app.ports.disconnected.send(null);
    client.removeAllListeners();
    client = null;
  });

  client.on('data', (data) => {
    // TODO: Completely gather an ack here
    app.ports.ack.send(data);
  });

  return client;
}

function send(hl7, callback) {
  client.write(hl7);

  // TODO: Call back once an ack has been received.
  callback();
}

function disconnect() {
  if (client) {
    // or client.end? This was what used to be used..
    client.destroy();
  }
}

function saveConnection(connectionName, ip, port, callback) {
  getSavedConnections((error, connections) => {
    if (error) {
      return callback(error);
    }

    let isNewConnection = false;
    let connection = connections.find((c) => c.name === connectionName);
    if (connection) {
      connection = getUpdatedConnection(connection, ip, port);
    } else {
      connection = getUpdatedConnection({}, ip, port);
      connection.name = connectionName;
      connections.push(connection);
      isNewConnection = true;
    }

    saveConnections(connections, (error) =>
      callback(error, isNewConnection)
    );
  });
}

function getUpdatedConnection(connection, ip, port) {
  connection.destinationIp = ip;
  connection.destinationPort = port;
  return connection;
}

function saveConnections(connections, callback) {
  saveUserDataObject(userDataFileName, connections, callback);
}

function getSavedConnections(callback) {
  getUserDataObject(userDataFileName, {}, callback);
}
