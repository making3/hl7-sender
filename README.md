HL7 Sender
==========

Desktop GUI tool for pasting and sending an HL7 message to a port. Mostly useful testing in-house systems or re-running individual messages.

# Project Board & Updates

For tracking future updates, view the [Trello board](https://trello.com/b/b3dkZJiG).

# Preview

This a work in progress, but here is a preview of the current state of the application.
![preview](https://i.imgur.com/xvBMfMs.png)

# Development

HL7 Sender is an Electron and Elm learning project.

# Installing

- Node.js v8+, v8 LTS is used for development.
  - [NVM](https://github.com/creationix/nvm) is recommended on linux.
  - [Official installers](https://nodejs.org/en/) are recommended on Windows
    - Or [nvm-windows](https://github.com/coreybutler/nvm-windows)


After NodeJS is installed:

    npm install


## Building

    // build elm views
    npm run build

    // build elm views & watch for changes
    npm run watch


## Running

    npm run start

    // starts + shows dev tools
    npm run debug

## Testing

For a test port, you may run the server. This server starts a TCP listener at IP 127.0.0.1 and port 1337

    npm run server

# Reference

- [Building a cross-platform desktop app with Electron and Elm](https://medium.com/@ezekeal/building-an-electron-app-with-elm-part-1-boilerplate-3416a730731f)
- [Structured TodoMVC example with Elm](https://medium.com/@_rchaves_/structured-todomvc-example-with-elm-a68d87cd38da)
