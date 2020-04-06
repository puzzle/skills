import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";

module("Integration | Component | activity-new", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders activity-new with no data submitted", async function(assert) {
    this.set("newActivity", {
      missesMonth() {
        if (!this.monthFrom || (!this.monthTo && this.yearTo)) return true;
        return false;
      }
    });
    await render(hbs`{{activity-new newActivity=newActivity}}`);
    this.$("button")[0].click();
    assert.equal(this.$("#missing-month-warning").css("display"), "block");
  });

  test("it renders activity-new with a missing month", async function(assert) {
    this.set("newActivity", {
      yearFrom: 1999,
      monthTo: 5,
      yearTo: 2000,
      missesMonth() {
        if (!this.monthFrom || (!this.monthTo && this.yearTo)) return true;
        return false;
      }
    });
    await render(
      hbs`{{activity-new newActivity=newActivity personId=personId}}`
    );
    this.$(".ember-text-field").val("Schlachter");
    this.$(".ember-text-area").val("Schlachten");
    this.$("button")[0].click();
    assert.equal(this.$("#missing-month-warning").css("display"), "block");
  });

  test("it renders activity-new with complete data submitted", async function(assert) {
    this.set("newActivity", {
      monthFrom: 5,
      yearFrom: 1999,
      monthTo: 5,
      yearTo: 2000,
      missesMonth() {
        if (!this.monthFrom || (!this.monthTo && this.yearTo)) return true;
        return false;
      },
      set(type, person) {},
      save() {
        return new Promise((resolve, reject) => {
          resolve();
        });
      }
    });
    this.set("personId", 2);
    await render(
      hbs`{{activity-new newActivity=newActivity personId=personId}}`
    );
    this.$(".ember-text-field").val("Aushilfe");
    this.$(".ember-text-area").val("Aushelfen");
    this.$("button")[0].click();
    assert.equal(this.$("#missing-month-warning").css("display"), "none");
  });
});
