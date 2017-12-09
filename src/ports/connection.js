'use strict';
const net = require('net');
let client;

exports.watchForEvents = (app) => {
    app.ports.connect.subscribe(([ ip, port /* end of transmission chars */ ]) => {
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
