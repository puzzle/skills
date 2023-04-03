import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | people-skill-show", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders people-skill-show with data", async function(assert) {
    this.set("peopleSkill", {
      skill: {
        title: "Rails"
      },
      level: 2,
      interest: 3,
      certificate: false,
      core_competence: true
    });

    await render(hbs`{{people-skill-show peopleSkill=peopleSkill}}`);

    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */

    assert.dom(".people-skill-title", document).includesText("Rails");
    assert.dom(".skillset-level-title", document).includesText("Junior");
    assert.equal(
      document.querySelectorAll(".icon-rating-icon")[0].getAttribute("style"),
      "color: #238BCA"
    );
    assert.equal(
      document.querySelectorAll(".icon-rating-icon")[1].getAttribute("style"),
      "color: #238BCA"
    );
    assert.equal(
      document.querySelectorAll(".icon-rating-icon")[2].getAttribute("style"),
      "color: #238BCA"
    );
    assert.equal(
      document.querySelectorAll(".icon-rating-icon")[3].getAttribute("style"),
      "color: #BDBDBD"
    );
    assert.equal(
      document.querySelectorAll(".icon-rating-icon")[4].getAttribute("style"),
      "color: #BDBDBD"
    );

    /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
  });
});
