import { module, test } from "qunit";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import applicationPage from "frontend/tests/pages/application";
import page from "frontend/tests/pages/person-edit";
import { selectChoose } from "ember-power-select/test-support";
import { setupIntl, t } from "ember-intl/test-support";

module("Acceptance | amount of", function(hooks) {
  setupApplicationTest(hooks);
  setupIntl(hooks);

  test("amount of educations", async function(assert) {
    assert.expect(4);

    await applicationPage.visitHome("/");
    /* eslint "no-undef": "off" */
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    // 1 education
    assert.equal(page.educations.list().count, 1);
    assert.equal(
      page.educations.amountOf,
      t("educations-show.education") + " (1)"
    );

    // 0 education
    await page.educations.toggleForm();
    await page.educations.delete();
    await page.educations.confirm();

    assert.equal(page.educations.list().count, 0);
    assert.equal(
      page.educations.amountOf,
      t("educations-show.education") + " (0)"
    );
  });
});
