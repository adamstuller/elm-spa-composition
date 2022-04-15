# Elm spa composition

School project used in master's degree thesis. Purpose of this project is to enable elegant widgets composition in single page applications in Elm.

Body of the project is located in the _src_ directory. Directory _example_ containes simple example of single page application with multiple page widgets, composed by our project.

## How to run the example

The simplest way to run the example is by using _elm reactor_.

For spa serving I used [http-server-spa](https://www.npmjs.com/package/http-server-spa). So if you want to use the same server, follow steps on the webpage to install it. Any webserver can be used however.

To run the example follow these steps:

1. `elm make example/Main.elm --output app.js`
2. `http-server-spa .`

## How to use it in another project

This should be published as elm package.

## TODO

- [x] Routes - with subroutes
- [x] Session or global state, Autorizacia
