'use strict';
const net = require('net');
const userData = require('./user-data');

let client;
const userDataFileName = 'connections.json';

exports.watchForEvents = (app) => {
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

    app.ports.saveConnection.subscribe(([ connectionName, ip, port ]) => {
        saveConnection(connectionName, ip, port, (error) => {
            console.log('done: ', error);
            // app.ports.savedConnection.send(error.toString());
        });
    });
};

function connect(app, ip, port) {
    client = new net.Socket();

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
        console.log('data: ', data);
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
        client.end();
    }
}

function saveConnection(connectionName, ip, port, callback) {
    getSavedConnections((error, connections) => {
        if (error) {
            return callback(error);
        }
        connections[connectionName] = {
            ip,
            port
        };
        const formattedConnections = userData.formatJson(connections);
        saveConnections(formattedConnections, callback);
    });
}

function saveConnections(connections, callback) {
    userData.saveUserData(userDataFileName, connections, callback);
}

function getSavedConnections(callback) {
    userData.getUserDataObject(userDataFileName, {}, callback);
}
