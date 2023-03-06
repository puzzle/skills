import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";

module("Integration | Component | activity-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render component with correct values", async function(assert) {
    assert.expect(3);

    this.set("mockActivity", {
      id: 1,
      role: "Designer who designs",
      description:
        "As a designer who designs I design designs for application to improve the UX design",
      monthFrom: 7,
      monthTo: 8,
      yearFrom: 1969,
      yearTo: 1970
    });

    await render(hbs`<ActivityShow @activity={{mockActivity}} />`);

    assert.equal(
      this.element.querySelector("#role").innerHTML,
      "Designer who designs"
    );
    assert.equal(
      this.element.querySelector("#description").innerHTML,
      "As a designer who designs I design designs for application to improve the UX design"
    );
    assert.equal(
      this.element.querySelector("#date").innerText,
      "07.1969 - 08.1970"
    );
  });
});
