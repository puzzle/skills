import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | projects-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render component with 3 projects in english", async function(assert) {
    assert.expect(6);

    setLocale("en");

    this.set("mockProjects", [
      {
        title: "Designing designs",
        description:
          "In this project we Designers design designs to improve UX design",
        role: "Designer",
        technology: "Design Pro+ HD XD Premium Gold",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1969,
        yearTo: 1970
      },
      {
        title: "Creating creations",
        description:
          "In this project we Creators create Creations to improve Creations",
        role: "Creator",
        technology: "Creator Pro+ HD XD Premium Gold",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1971,
        yearTo: 1972
      },
      {
        title: "Talking nonsense",
        description:
          "In this project us Flat-Earthers talk nonsense to confuse people",
        role: "Nonsense talker",
        technology: "Rahmbüchse Pro+ HD XD Premium Gold",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1973,
        yearTo: 1974
      }
    ]);

    await render(hbs`<ProjectsShow @projects={{mockProjects}} />`);

    assert.equal(
      this.element.querySelector("#amount-of-projects").innerText,
      "Projects (3)"
    );
    assert.equal(
      this.element.querySelector("#add-projects-button").innerText,
      "Add project"
    );
    assert.equal(this.element.querySelectorAll(".project-row").length, 3);
    //check if activities were sorted by year
    assert.ok(
      this.element
        .querySelectorAll(".project-row")[0]
        .textContent.includes("Talking nonsense")
    );
    assert.ok(
      this.element
        .querySelectorAll(".project-row")[1]
        .textContent.includes("Creating creations")
    );
    assert.ok(
      this.element
        .querySelectorAll(".project-row")[2]
        .textContent.includes("Designing designs")
    );
  });

  test("should render component with 1 project in german", async function(assert) {
    assert.expect(3);

    setLocale("de");

    this.set("mockProjects", [
      {
        title: "Designing designs",
        description:
          "In this project we Designers design designs to improve UX design",
        role: "Designer",
        technology: "Design Pro+ HD XD Premium Gold",
        monthFrom: 7,
        monthTo: 8,
        yearFrom: 1969,
        yearTo: 1970
      }
    ]);

    await render(hbs`<ProjectsShow @projects={{mockProjects}} />`);

    assert.equal(
      this.element.querySelector("#amount-of-projects").innerText,
      "Projekte (1)"
    );
    assert.equal(
      this.element.querySelector("#add-projects-button").innerText,
      "Projekt hinzufügen"
    );
    assert.equal(this.element.querySelectorAll(".project-row").length, 1);
  });
});
