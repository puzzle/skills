import { setApplication } from "@ember/test-helpers";
import Application from "../app";
import { start } from "ember-qunit";
import config from "../config/environment";
import * as QUnit from "qunit";
import { setup } from "qunit-dom";

setup(QUnit.assert);

setApplication(Application.create(config.APP));

start();
