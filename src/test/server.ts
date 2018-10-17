import { createServer } from 'net';

const clients = [];
const server = createServer();

/*
    TODO:
    - Send an ACK with encoding characters
*/
server.on('connection', (socket) => {
  clients.push(socket);
  console.log('client connect, count: ', clients.length);

  socket.on('data', (data) => {
    console.log(data.toString());
  });

  socket.on('close', () => {
    clients.splice(clients.indexOf(socket), 1);
    console.log('disconnected, count: ', clients.length);
  });
});

server.listen(1337, '127.0.0.1');
