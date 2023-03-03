import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | educations-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render component with 3 educations in english", async function(assert) {
    assert.expect(6);

    setLocale("en");

    this.set("mockEducations", [
      {
        id: 1,
        title: "Master of Design",
        location: "Gibb",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1969,
        yearTo: 1970
      },
      {
        id: 2,
        title: "Master of Creation",
        location: "Gibb",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1971,
        yearTo: 1972
      },
      {
        id: 3,
        title: "Master of Nonsense",
        location: "Gibb",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1973,
        yearTo: 1974
      }
    ]);

    await render(hbs`<EducationsShow @educations={{mockEducations}} />`);

    assert.equal(
      this.element.querySelector("#amount-of-educations").innerText,
      "Education (3)"
    );
    assert.equal(
      this.element.querySelector("#add-education-button").innerText,
      "Add education"
    );
    assert.equal(this.element.querySelectorAll(".education-row").length, 3);
    //check if educations were sorted by year
    assert.ok(
      this.element
        .querySelectorAll(".education-row")[0]
        .textContent.includes("Master of Nonsense")
    );
    assert.ok(
      this.element
        .querySelectorAll(".education-row")[1]
        .textContent.includes("Master of Creation")
    );
    assert.ok(
      this.element
        .querySelectorAll(".education-row")[2]
        .textContent.includes("Master of Design")
    );
  });

  test("should render component with 1 educations in german", async function(assert) {
    assert.expect(4);

    setLocale("de");

    this.set("mockEducations", [
      {
        id: 1,
        title: "Master of Design",
        location: "Gibb",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1969,
        yearTo: 1970
      }
    ]);

    await render(hbs`<EducationsShow @educations={{mockEducations}} />`);

    assert.equal(
      this.element.querySelector("#amount-of-educations").innerText,
      "Ausbildung (1)"
    );
    assert.equal(
      this.element.querySelector("#add-education-button").innerText,
      "Ausbildung hinzufügen"
    );
    assert.equal(this.element.querySelectorAll(".education-row").length, 1);
    //check if educations were sorted by year
    assert.ok(
      this.element
        .querySelectorAll(".education-row")[0]
        .textContent.includes("Master of Design")
    );
  });
});
