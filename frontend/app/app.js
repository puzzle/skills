import Application from "@ember/application";
import RSVP from "rsvp";
import Resolver from "./resolver";
import loadInitializers from "ember-load-initializers";
import config from "./config/environment";
import { startSentry } from "./sentry";

window.Promise = RSVP.Promise;
startSentry();

const App = Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver
});

loadInitializers(App, config.modulePrefix);

export default App;
