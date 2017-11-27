'use strict';
const net = require('net');

/* TODO
    - Handle data
*/

let client;

exports.watchForConnect = (app) => {
    app.ports.connect.subscribe(([ ip, port ]) => {
        console.log('args: ', ip);
        console.log('args: ', port);

        client = new net.Socket();

        client.connect(port, ip, (e) => {
            console.log('e: ', e);
            app.ports.connected.send('');
        });

        client.on('error', (error) => {
            console.log('error: ', error);
            app.ports.connectionError.send(error.toString());
        });

        client.on('close', () => {
            app.ports.disconnected.send('');
            client.removeAllListeners();
            client = null;
        });
    });
};

exports.watchForDisconnect = (app) => {
    app.ports.disconnect.subscribe(() => {
        if (client) {
            client.end();
        }
    });
};
