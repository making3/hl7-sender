'use strict';
const net = require('net');

/* TODO
    - Handle data
*/

let client;

exports.watchForEvents = (app) => {
    app.ports.connect.subscribe(([ ip, port /* end of transmission chars */ ]) => {
        client = connect(app, ip, port);
    });

    app.ports.disconnect.subscribe(() => {
        disconnect();
    });

    app.ports.send.subscribe((hl7) => {
        send(hl7);
    });
};

function connect(app, ip, port) {
    client = new net.Socket();

    client.connect(port, ip, () => {
        app.ports.connected.send('');
    });

    client.on('error', (error) => {
        app.ports.connectionError.send(error.toString());
    });

    client.on('close', () => {
        app.ports.disconnected.send('');
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

function send(hl7) {
    client.write(hl7);
}

function disconnect() {
    if (client) {
        client.end();
    }
}
