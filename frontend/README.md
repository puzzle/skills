<p align="center">
  <a href="https://github.com/puzzle/skills">
    <img src="https://skills.puzzle.ch/logo.svg"  width="400" height="82">
  </a>
</p>

# Frontend

This is the Frontend part of the PuzzleSkills setup documentation  
The Frontend is built with [Ember.js](https://emberjs.com/)

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
