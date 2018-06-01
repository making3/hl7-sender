HL7 Sender
==========

Desktop GUI tool for pasting and sending an HL7 message to a port. Mostly useful testing in-house systems or re-running individual messages.

# Preview

This a work in progress, but here is a preview of the current state of the application.
![preview](https://i.imgur.com/xvBMfMs.png)

# Development

HL7 Sender is an Electron and Elm learning project. Refer to the [TODO](TODO.md) for upcoming tasks / features.

# Installing

- Node.js v8+, v8 LTS is used for development.
  - [NVM](https://github.com/creationix/nvm) is recommended on linux.
  - Official installers are recommended on Windows, or [nvm-windows](https://github.com/coreybutler/nvm-windows)


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

# Reference

- [Building a cross-platform desktop app with Electron and Elm](https://medium.com/@ezekeal/building-an-electron-app-with-elm-part-1-boilerplate-3416a730731f)
- [Structured TodoMVC example with Elm](https://medium.com/@_rchaves_/structured-todomvc-example-with-elm-a68d87cd38da)
