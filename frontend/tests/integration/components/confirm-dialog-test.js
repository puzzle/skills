import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render, click } from "@ember/test-helpers";
import { hbs } from "ember-cli-htmlbars";
import { setLocale } from "ember-intl/test-support";
import sinon from "sinon";

module("Integration | Component | confirm-dialog", function(hooks) {
  setupRenderingTest(hooks);

  test("should render all english translations in confirm dialog correctly", async function(assert) {
    assert.expect(3);

    setLocale("en");

    await render(
      hbs`<ConfirmDialog @showModal=true @confirmText={{t "education-form.closeDialogText" }} />`
    );

    assert.equal(
      this.element.querySelector("#confirm-text").innerText,
      "Do you really want to close this form?"
    );
    assert.equal(
      this.element.querySelector("#confirm-button").innerText,
      "Confirm"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerText,
      "Cancel"
    );
  });

  test("should render all german translations in confirm dialog correctly", async function(assert) {
    assert.expect(3);

    setLocale("de");

    await render(
      hbs`<ConfirmDialog @showModal={{true}} @confirmText={{t "education-form.closeDialogText" }} />`
    );

    assert.equal(
      this.element.querySelector("#confirm-text").innerText,
      "Möchtest du dieses Forumular wirklich schliessen?"
    );
    assert.equal(
      this.element.querySelector("#confirm-button").innerText,
      "Bestätigen"
    );
    assert.equal(
      this.element.querySelector("#cancel-button").innerText,
      "Abbrechen"
    );
  });

  test("should display nothing when not showing modal", async function(assert) {
    assert.expect(1);

    await render(hbs`<ConfirmDialog @showModal={{false}} />`);

    assert
      .dom(this.element.querySelector("#confirmation-modal"))
      .doesNotExist();
  });

  test("should click confirm button and trigger parent function", async function(assert) {
    assert.expect(1);

    const parentSpy = sinon.spy();
    this.set("onConfirm", parentSpy);

    await render(
      hbs`<ConfirmDialog @showModal={{true}} @onConfirm={{this.onConfirm}} />`
    );

    await click("#confirm-button");

    assert.ok(parentSpy.calledOnce);
  });

  test("should click cancel button and trigger parent function", async function(assert) {
    assert.expect(1);

    const parentSpy = sinon.spy();
    this.set("onCancel", parentSpy);

    await render(
      hbs`<ConfirmDialog @showModal={{true}} @onCancel={{this.onCancel}} />`
    );

    await click("#cancel-button");

    assert.ok(parentSpy.calledOnce);
  });
});
