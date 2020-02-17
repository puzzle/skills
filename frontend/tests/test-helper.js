import { setApplication } from "@ember/test-helpers";
import Application from "../app";
import { start } from "ember-qunit";
import config from "../config/environment";

setApplication(Application.create(config.APP));

start();
