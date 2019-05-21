import { test } from "qunit";
import moduleForAcceptance from "frontend/tests/helpers/module-for-acceptance";
import { authenticateSession } from "frontend/tests/helpers/ember-simple-auth";
import applicationPage from "frontend/tests/pages/application";
import page from "frontend/tests/pages/person-edit";

moduleForAcceptance("Acceptance | amount of", {
  beforeEach() {
    authenticateSession(this.application, {
      ldap_uid: "development_user",
      token: "1234"
    });
  }
});

test("amount of educations", async function(assert) {
  assert.expect(4);

  await applicationPage.visitHome("/");
  /* eslint "no-undef": "off" */
  await selectChoose("#people-search", ".ember-power-select-option", 0);

  // 1 education
  assert.equal(page.educations.list().count, 1);
  assert.equal(page.educations.amountOf, "Ausbildung (1)");

  // 0 education
  await page.educations.toggleForm();
  await page.educations.delete();
  await page.educations.confirm();
  await page.educations.submit();

  assert.equal(page.educations.list().count, 0);
  assert.equal(page.educations.amountOf, "Ausbildung (0)");
});
