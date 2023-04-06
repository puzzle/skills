import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";

module("Integration | Component | rated-skill-show", function(hooks) {
  setupRenderingTest(hooks);

  test("should render rated skill show with all values", async function(assert) {
    assert.expect(7);

    await render(
      // eslint-disable-next-line max-len
      hbs`<RatedSkillShow @title={{"Lachsfilet zubereiten"}} @level={{"1"}} @interest={{"1"}} @certificate={{true}} @coreCompetence={{true}} @showSkillTitle={{true}} />`
    );

    assert.equal(
      this.element.querySelector("#title-label").innerText,
      "Lachsfilet zubereiten"
    );
    assert.equal(
      this.element.querySelector("#level-name-label").innerText,
      "Trainee"
    );
    assert.ok(
      this.element.querySelector("#level-label").innerHTML.includes('value="1"')
    );
    assert
      .dom(this.element.querySelector("#checkbox-certificate-enabled"))
      .exists();
    assert
      .dom(this.element.querySelector("#checkbox-certficate-disabled"))
      .doesNotExist();
    assert
      .dom(this.element.querySelector("#checkbox-core-competence-enabled"))
      .exists();
    assert
      .dom(this.element.querySelector("#checkbox-core-competence-disabled"))
      .doesNotExist();
  });

  test("should render rated skill show without title", async function(assert) {
    assert.expect(7);

    await render(
      // eslint-disable-next-line max-len
      hbs`<RatedSkillShow @title={{"Lachsfilet zubereiten"}} @level={{"3"}} @interest={{"3"}} @certificate={{false}} @coreCompetence={{false}} @showSkillTitle={{false}} />`
    );

    assert.dom(this.element.querySelector("#title-label")).doesNotExist();
    assert.ok(
      this.element.querySelector("#level-label").innerHTML.includes('value="3"')
    );
    assert.equal(
      this.element.querySelector("#level-name-label").innerText,
      "Professional"
    );
    assert
      .dom(this.element.querySelector("#checkbox-certificate-enabled"))
      .doesNotExist();
    assert
      .dom(this.element.querySelector("#checkbox-certificate-disabled"))
      .exists();
    assert
      .dom(this.element.querySelector("#checkbox-core-competence-enabled"))
      .doesNotExist();
    assert
      .dom(this.element.querySelector("#checkbox-core-competence-disabled"))
      .exists();
  });

  test("should render all english translations correctly", async function(assert) {
    assert.expect(2);

    setLocale("en");

    await render(hbs`<RatedSkillShow />`);

    assert.equal(
      this.element.querySelector("#certificate-label").innerHTML,
      "Certificate"
    );
    assert.equal(
      this.element.querySelector("#core-competence-label").innerHTML,
      "Core competence"
    );
  });

  test("should render all german translations correctly", async function(assert) {
    assert.expect(2);

    setLocale("de");

    await render(hbs`<RatedSkillShow />`);

    assert.equal(
      this.element.querySelector("#certificate-label").innerHTML,
      "Zertifikat"
    );
    assert.equal(
      this.element.querySelector("#core-competence-label").innerHTML,
      "Kernkompetenz"
    );
  });
});
