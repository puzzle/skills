import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import Service from "@ember/service";
import { setupIntl } from "ember-intl/test-support";

const storeStub = Service.extend({
  createRecord(type, options) {
    return {
      set(attr, val) {
        return null;
      },
      skill: { title: "Rails" },
      level: 0,
      interest: 0,
      certificate: false,
      coreCompetence: false
    };
  }
});

const ajaxStub = Service.extend({
  request(url, options) {
    return new Promise(function(resolve, reject) {
      resolve({
        data: [
          {
            title: "Rails",
            id: 1
          }
        ]
      });

      reject("fail");
    });
  }
});

module("Integration | Component | new-people-skills-show", function(hooks) {
  setupRenderingTest(hooks);
  setupIntl(hooks);

  test("it renders", async function(assert) {
    this.owner.unregister("service:store");
    this.owner.unregister("service:ajax");
    this.owner.register("service:store", storeStub);
    this.owner.register("service:ajax", ajaxStub);

    this.set(
      "skills",
      Promise.all([
        {
          title: "JUnit",
          get(attr) {
            return 1;
          }
        },
        {
          title: "Rails",
          get(attr) {
            return 2;
          }
        }
      ])
    );
    await render(hbs`{{new-people-skills-show skills=skills}}`);

    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    let text = $().text();
    /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */

    assert.dom().includesText("t:new-people-skills-show.newSkills");
    assert.ok(text.includes("Rails"));
    assert.ok(text.includes("Nicht bewertet"));
    assert.ok(text.includes("Interesse"));
    assert.ok(text.includes("Zertifikat"));
    assert.ok(text.includes("Kernkompetenz"));
    assert.dom().includesText("t:new-people-skills-show.dontRate");
  });
});
