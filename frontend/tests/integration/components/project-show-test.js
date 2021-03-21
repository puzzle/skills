import { module, skip, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | project show", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders project", async function(assert) {
    this.set("project", {
      title: "Dreaming Project",
      lineBreakDescription: "Schlafen",
      lineBreakRole: "Träumer",
      yearFrom: 1990,
      monthFrom: 2,
      yearTo: 1991,
      monthTo: 2,
      lineBreakTechnology: "Java"
    });

    await render(hbs`{{project-show
      project=project
      selectProject=(action (mut projectEditing))
    }}`);

    assert.ok(this.element.textContent.includes("Dreaming Project"));
    assert.ok(this.element.textContent.includes("Schlafen"));
    assert.ok(this.element.textContent.includes("Träumer"));
    assert.ok(this.element.textContent.includes("1990"));
    assert.ok(this.element.textContent.includes("1991"));
    assert.ok(this.element.textContent.includes("Java"));
  });

  skip("project description, role and technology preserves whitespace", function(assert) {
    this.set("activity", {
      description: "Preserves\nwhitespaces",
      role: "Träumer",
      year_from: "1990",
      year_to: "1991"
    });

    this.set("project", {
      title: "Dreaming Project",
      description: "Schlafen",
      role: "Träumer",
      technology: "Ruby",
      year_from: "1990",
      year_to: "1991"
    });

    this.render(hbs`{{project-show
      project=project
      selectProject=(action (mut projectEditing))
    }}`);

    let $elements = this.$(
      '[href="#collapseProjectDreaming Project"].project-title-text,' +
        '[id="collapseProjectDreaming Project"] div.col-sm-10'
    );

    assert.equal($elements.length, 2);
  });
});
