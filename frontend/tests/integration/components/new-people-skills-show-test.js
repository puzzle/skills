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

    assert
      .dom(".col-md-11", document)
      .includesText("t:new-people-skills-show.newSkills:()");
    assert.dom(".people-skill-skillname", document).includesText("Rails");
    assert
      .dom(".member-skillset-level-title", document)
      .includesText("Nicht bewertet");
    assert
      .dom(".member-skillset-interest-title", document)
      .includesText("Interesse");
    assert.equal(
      document.querySelectorAll(".description.ml-2.mb-0")[0].innerHTML,
      "Zertifikat"
    );
    assert.equal(
      document.querySelectorAll(".description.ml-2.mb-0")[1].innerHTML,
      "Kernkompetenz"
    );
    assert
      .dom(".edit-buttons", document)
      .includesText("t:new-people-skills-show.dontRate:()");
  });
});
