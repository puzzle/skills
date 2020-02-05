<p align="center">
  <a href="https://github.com/puzzle/skills">
    <img src="https://skills.puzzle.ch/logo.svg"  width="400" height="82">
  </a>
</p>

# Frontend

This is the Frontend part of the PuzzleSkills setup documentation  
The Frontend is built with [Ember.js](https://emberjs.com/)

## Prerequisites

You will need the following things properly installed on your computer.

* [Git](https://git-scm.com/)
* [Node.js](https://nodejs.org/) (with NPM)
* [Ember CLI](https://ember-cli.com/)
* [NVM](https://github.com/creationix/nvm)

## Installation Guide

Install node version 8 with the Node Version Manager
```shell
nvm install 8
```
Install Ember-Cli with NPM
```shell
npm install -g ember-cli
```
Go into the frontend folder of the project
```shell
cd frontend
```
There, run yarn install which will install all the packages
```shell
yarn install
```

## Running / Development

With the rails backend server running you can start the frontend, directing it at the rails server on port 3000

```shell
ember server --proxy=http://localhost:3000
```
Congratulations the PuzzleSkills Application is now online, you can visit it at

##### <code> [http://localhost:4200](http://localhost:4200) </code>

## Documentation

### Code Generators

Make use of the Ember code generators, try `ember help generate` for more details

### Running Tests

To run the frontend test use the following command:
```shell
rake spec:frontend
```

To run a single frontend test use the following command

```shell
ember test --filter="test's title"
```
or select the test from the dropdown in the test browser.

### Building

Building for development:
```shell
ember build
```
Building for production:
```shell
ember build --environment production
```


### Browser Extension
Use the Ember Inspector for easier debugging of the Frontend Application

* [Ember inspector for Chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)  
* [Ember inspector for Firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)
