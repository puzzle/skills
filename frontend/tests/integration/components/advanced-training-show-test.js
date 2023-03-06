import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";

module("Integration | Component | advanced-training-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render component with correct values", async function(assert) {
    assert.expect(2);

    this.set("mockAdvancedTraining", {
      id: 1,
      description:
        "I learned to design to be a designer who designs a lot of nice designs",
      monthFrom: 7,
      monthTo: 8,
      yearFrom: 1969,
      yearTo: 1970
    });

    await render(
      hbs`<AdvancedTrainingShow @advancedTraining={{mockAdvancedTraining}} />`
    );
    assert.equal(
      this.element.querySelector("#description").innerHTML,
      "I learned to design to be a designer who designs a lot of nice designs"
    );
    assert.equal(
      this.element.querySelector("#date").innerText,
      "07.1969 - 08.1970"
    );
  });
});
