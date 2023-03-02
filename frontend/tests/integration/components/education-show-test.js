import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";

module("Integration | Component | education-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render component with correct values", async function(assert) {
    assert.expect(3);

    this.set("mockEducation", {
      id: 1,
      title: "Master of Design",
      location: "Gibb",
      monthFrom: 7,
      monthTo: 8,
      yearFrom: 1969,
      yearTo: 1970
    });

    await render(hbs`<EducationShow @education={{mockEducation}} />`);

    assert.equal(
      this.element.querySelector("#title").innerHTML,
      "Master of Design"
    );
    assert.equal(this.element.querySelector("#location").innerHTML, "Gibb");
    assert.equal(
      this.element.querySelector("#date").innerText,
      "07.1969 - 08.1970"
    );
  });
});
