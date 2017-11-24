HL7 Sender
==========

# Installing

- Node.js. Use NVM.

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
