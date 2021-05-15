import { run } from "@ember/runloop";
import Application from "../../app";
import config from "../../config/environment";
import registerPowerSelectHelpers from "ember-power-select/test-support/helpers";
import { setContext } from "ember-test-helpers";

registerPowerSelectHelpers();

export default function startApp(attrs) {
  let attributes = assign({}, config.APP);
  attributes = assign(attributes, attrs); // use defaults, but you can override;

  return run(() => {
    let application = Application.create(attributes);
    application.setupForTesting();
    application.injectTestHelpers();
    /* eslint "no-undef": "off" */
    QUnit.config.current.testEnvironment.owner =
      application.__deprecatedInstance__;
    setContext(QUnit.config.current.testEnvironment);
    return application;
  });
}
