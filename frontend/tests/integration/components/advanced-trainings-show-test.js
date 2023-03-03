import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | advanced-trainings-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render component with 3 adnvanced trainings in english", async function(assert) {
    assert.expect(6);

    setLocale("en");

    this.set("mockAdvancedTrainings", [
      {
        id: 1,
        description:
          "I learned to design to be a designer who designs a lot of nice designs",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1969,
        yearTo: 1970
      },
      {
        id: 1,
        description:
          "I learned to create to be a creator who creates a lot of nice Creations",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1971,
        yearTo: 1972
      },
      {
        id: 1,
        description:
          "I learned to talk nonsense to be a person who talks nonsense to others who believe in nonsense",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1973,
        yearTo: 1974
      }
    ]);

    await render(
      hbs`<AdvancedTrainingsShow @advancedTrainings={{mockAdvancedTrainings}} />`
    );

    assert.equal(
      this.element.querySelector("#amount-of-advanced-trainings").innerText,
      "Advanced Training (3)"
    );
    assert.equal(
      this.element.querySelector("#add-advanced-trainings-button").innerText,
      "Add advanced training"
    );
    assert.equal(
      this.element.querySelectorAll(".advanced-training-row").length,
      3
    );
    //check if advanced trainings were sorted by year
    assert.ok(
      this.element
        .querySelectorAll(".advanced-training-row")[0]
        .textContent.includes(
          "I learned to talk nonsense to be a person who talks nonsense to others who believe in nonsense"
        )
    );
    assert.ok(
      this.element
        .querySelectorAll(".advanced-training-row")[1]
        .textContent.includes(
          "I learned to create to be a creator who creates a lot of nice Creations"
        )
    );
    assert.ok(
      this.element
        .querySelectorAll(".advanced-training-row")[2]
        .textContent.includes(
          "I learned to design to be a designer who designs a lot of nice designs"
        )
    );
  });

  test("should render component with 1 advanced training in german", async function(assert) {
    assert.expect(4);

    setLocale("de");

    this.set("mockAdvancedTraining", [
      {
        id: 1,
        description:
          "I learned to design to be a designer who designs a lot of nice designs",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1969,
        yearTo: 1970
      }
    ]);

    await render(
      hbs`<AdvancedTrainingsShow @advancedTrainings={{mockAdvancedTraining}} />`
    );

    assert.equal(
      this.element.querySelector("#amount-of-advanced-trainings").innerText,
      "Weiterbildung (1)"
    );
    assert.equal(
      this.element.querySelector("#add-advanced-trainings-button").innerText,
      "Weiterbildung hinzufügen"
    );
    assert.equal(
      this.element.querySelectorAll(".advanced-training-row").length,
      1
    );
    //check if advanced trainings were sorted by year
    assert.ok(
      this.element
        .querySelectorAll(".advanced-training-row")[0]
        .textContent.includes(
          "I learned to design to be a designer who designs a lot of nice designs"
        )
    );
  });
});
