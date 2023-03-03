import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | activities-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render component with 3 activities in english", async function(assert) {
    assert.expect(6);

    setLocale("en");

    this.set("mockActivities", [
      {
        id: 1,
        role: "Designer who designs",
        description:
          "As a designer who designs I design designs for applications to improve the UX design",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1969,
        yearTo: 1970
      },
      {
        id: 2,
        role: "Creator who creates",
        description:
          "As a Creator who creates I create Creations for Creations to improve the Creation",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1971,
        yearTo: 1972
      },
      {
        id: 1,
        role: "Flat-Earther who talks nonsense",
        description:
          "As a Flatearther who talks nonsense I talk nonsense for flat earth theories to improve the overall nonsense",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1973,
        yearTo: 1974
      }
    ]);

    await render(hbs`<ActivitiesShow @activities={{mockActivities}} />`);

    assert.equal(
      this.element.querySelector("#amount-of-activities").innerText,
      "Activities (3)"
    );
    assert.equal(
      this.element.querySelector("#add-activity-button").innerText,
      "Add activity"
    );
    assert.equal(this.element.querySelectorAll(".activity-row").length, 3);
    //check if activities were sorted by year
    assert.ok(
      this.element
        .querySelectorAll(".activity-row")[0]
        .textContent.includes("Flat-Earther who talks nonsense")
    );
    assert.ok(
      this.element
        .querySelectorAll(".activity-row")[1]
        .textContent.includes("Creator who creates")
    );
    assert.ok(
      this.element
        .querySelectorAll(".activity-row")[2]
        .textContent.includes("Designer who designs")
    );
  });

  test("should render component with 1 activity in german", async function(assert) {
    assert.expect(4);

    setLocale("de");

    this.set("mockActivities", [
      {
        id: 1,
        role: "Designer who designs",
        description:
          "As a designer who designs I design designs for applications to improve the UX design",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1969,
        yearTo: 1970
      }
    ]);

    await render(hbs`<ActivitiesShow @activities={{mockActivities}} />`);

    assert.equal(
      this.element.querySelector("#amount-of-activities").innerText,
      "Stationen (1)"
    );
    assert.equal(
      this.element.querySelector("#add-activity-button").innerText,
      "Station hinzufügen"
    );
    assert.equal(this.element.querySelectorAll(".activity-row").length, 1);
    //check if activities were sorted by year
    assert.ok(
      this.element
        .querySelectorAll(".activity-row")[0]
        .textContent.includes("Designer who designs")
    );
  });
});
