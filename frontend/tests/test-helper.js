import resolver from "./helpers/resolver";
import { setResolver, setApplication } from "@ember/test-helpers";
import registerPowerSelectHelpers from "ember-power-select/test-support/helpers";
import Application from "../app";
import { start } from "ember-qunit";
import config from "../config/environment";

setApplication(Application.create(config.APP));

start();
