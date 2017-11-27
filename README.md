HL7 Sender
==========

Desktop GUI tool for pasting and sending an HL7 message to a port. Mostly useful testing in-house systems or re-running individual messages.

# Development

This app is currently in development with very basic features. This is also an Electron & Elm learning project.

# Installing

Node.js. Use NVM.


    // Elm & Electron
    npm i -g elm electron-prebuilt

    // Elm dependencies (not sure if required)
    elm package install elm-lang/html

    // Change detection / automatic reloading
    npm i -g chokidar-cli

## Building

    // Build Elm project
    elm make Main.elm --output elm.js

    // or
    npm run elm

    // or build & watch for changes
    npm run elm:watch


## Running

    // Run electron
    electron main.js

    // or
    npm run start

    // or build & watch for changes
    npm run watch

# Reference

- [Building a cross-platform desktop app with Electron and Elm](https://medium.com/@ezekeal/building-an-electron-app-with-elm-part-1-boilerplate-3416a730731f)
