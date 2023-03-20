import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import { tracked } from "@glimmer/tracking";

module("Integration | Component | daterange-edit", function(hooks) {
  /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */

  setupRenderingTest(hooks);

  test("it renders daterange-edit with data and month", async function(assert) {
    this.set("project", {
      yearFrom: 2000,
      monthFrom: 10,
      yearTo: 2005,
      monthTo: 3
    });

    await render(hbs`{{daterange-edit entity=project}}`);

    let months = $(".ember-power-select-selected-item");
    let years = $("input[type=number]");

    assert.equal(months[0].innerText, "10");
    assert.equal(months[1].innerText, "3");
    assert.equal(years[0].valueAsNumber, 2000);
    assert.equal(years[1].valueAsNumber, 2005);
  });

  test("it renders daterange-edit with data no month", async function(assert) {
    this.set("project", {
      yearFrom: 2000,
      monthFrom: null,
      yearTo: 2005,
      monthTo: null
    });

    await render(hbs`{{daterange-edit entity=project}}`);

    let months = $(".ember-power-select-selected-item");
    let years = $("input[type=number]");

    assert.equal(months[0].innerText, "-");
    assert.equal(months[1].innerText, "-");
    assert.equal(years[0].valueAsNumber, 2000);
    assert.equal(years[1].valueAsNumber, 2005);
  });

  test("it renders daterange-edit without data", async function(assert) {
    this.set("project", {
      isNew: true
    });

    await render(hbs`{{daterange-edit entity=project}}`);

    let months = $(".ember-power-select-selected-item");
    let years = $("input[type=number]");

    assert.equal(months[0].innerText, "-");
    assert.equal(months[1].innerText, "-");
    assert.equal(years[0].value, "");
    assert.equal(years[1].value, "");
  });

  test("it takes over values of from fields when calendar icon clicked", async function(assert) {
    this.set("project", {
      yearFrom: 2000,
      monthFrom: 10,
      @tracked yearTo: 2005,
      @tracked monthTo: 9
    });

    await render(hbs`{{daterange-edit entity=project}}`);

    let calendarIcon = this.$(".btn-primary");
    calendarIcon.click();

    assert.equal(this.project.monthTo, 10);
    assert.equal(this.project.yearTo, 2000);
  });

  test("it takes over values of from fields when from fields are edited", async function(assert) {
    this.set("project", {
      yearFrom: 1960,
      monthFrom: 1,
      @tracked yearTo: 2000,
      @tracked monthTo: 10
    });

    await render(hbs`{{daterange-edit entity=project}}`);

    let calendarIcon = this.$(".btn-primary");
    calendarIcon.click();
    this.project.yearTo = 1980;

    assert.equal(this.project.monthTo, 1);
    assert.equal(this.project.yearTo, 1980);
  });

  /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
});
