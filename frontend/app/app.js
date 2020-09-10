import Application from "@ember/application";
import RSVP from "rsvp";
import Resolver from "./resolver";
import loadInitializers from "ember-load-initializers";
import config from "./config/environment";

window.Promise = RSVP.Promise;

export default class App extends Application {
  modulePrefix = config.modulePrefix;
  podModulePrefix = config.podModulePrefix;
  Resolver = Resolver;
}

loadInitializers(App, config.modulePrefix);
