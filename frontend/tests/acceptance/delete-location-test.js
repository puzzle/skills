import { module, test, skip } from "qunit";
import applicationPage from "frontend/tests/pages/application";
import page from "frontend/tests/pages/location-delete";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL } from "@ember/test-helpers";

module("Acceptance | delete location", function(hooks) {
  setupApplicationTest(hooks);

  skip("submit delete location", async function(assert) {
    assert.expect(11);

    await applicationPage.visitCompanies("/companies");
    await applicationPage.companiesMenuItem("Firma");

    assert.equal(page.profileData.locations, "Bern");

    await page.toggleEditForm();
    await page.pressDeleteButton();
    await page.deleteConfirmation.submit();
    await page.editForm.submit();

    assert.equal(page.profileData.name, "Firma");
    assert.equal(page.profileData.web, "www.example.com");
    assert.equal(page.profileData.email, "info@example.com");
    assert.equal(page.profileData.phone, "+41 00 000 00 00");
    assert.equal(page.profileData.partnermanager, "Urs Müller");
    assert.equal(page.profileData.contactPerson, "Philip Müller");
    assert.equal(page.profileData.emailContactPerson, "pmueller@example.com");
    assert.equal(page.profileData.crm, "crm");
    assert.equal(page.profileData.level, "A");
    assert.equal(page.profileData.locations, "");
  });

  skip("cancel delete location", async function(assert) {
    assert.expect(11);

    await applicationPage.visitCompanies("/companies");
    await applicationPage.companiesMenuItem("Firma");

    assert.equal(page.profileData.locations, "Bern");

    await page.toggleEditForm();
    await page.pressDeleteButton();
    await page.deleteConfirmation.cancel();
    await page.editForm.submit();

    assert.equal(page.profileData.name, "Firma");
    assert.equal(page.profileData.web, "www.example.com");
    assert.equal(page.profileData.email, "info@example.com");
    assert.equal(page.profileData.phone, "+41 00 000 00 00");
    assert.equal(page.profileData.partnermanager, "Urs Müller");
    assert.equal(page.profileData.contactPerson, "Philip Müller");
    assert.equal(page.profileData.emailContactPerson, "pmueller@example.com");
    assert.equal(page.profileData.crm, "crm");
    assert.equal(page.profileData.level, "A");
    assert.equal(page.profileData.locations, "Bern");
  });
});
