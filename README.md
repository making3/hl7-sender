HL7 Sender
==========

Desktop GUI tool for pasting and sending an HL7 message to a port. Mostly useful testing in-house systems or re-running individual messages.

# Preview

This a work in progress, but here is a preview of the current state of the application.
![preview](https://i.imgur.com/xvBMfMs.png)

# Development

HL7 Sender is an Electron and Elm learning project. Refer to the [TODO](TODO.md) for upcoming tasks / features.

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

    // or debug it
    npm run debug

    // or build & watch for changes
    npm run watch

# Reference

- [Building a cross-platform desktop app with Electron and Elm](https://medium.com/@ezekeal/building-an-electron-app-with-elm-part-1-boilerplate-3416a730731f)
- [Structured TodoMVC example with Elm](https://medium.com/@_rchaves_/structured-todomvc-example-with-elm-a68d87cd38da)
