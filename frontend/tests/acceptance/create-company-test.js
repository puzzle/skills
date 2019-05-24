import { test } from "qunit";
import moduleForAcceptance from "frontend/tests/helpers/module-for-acceptance";
import page from "frontend/tests/pages/company-new";
import editPage from "frontend/tests/pages/company-edit";

moduleForAcceptance("Acceptance | create company");

test("creating a new company with location and employee quantity", async function(assert) {
  assert.expect(15);

  await page.visit();

  assert.equal(currentURL(), "/companies/new");

  await click("[data-test-add-location]");
  await fillIn("[data-test-location] input", "Unterägeri");

  await click("[data-test-add-employee-quantity]");
  await fillIn("[data-test-employee-quantity-category] input", "Diener");
  await fillIn("[data-test-employee-quantity-quantity] input", "42");

  await page.createCompany({
    name: "Hirschi AG",
    web: "www.hirschi.ag",
    email: "info@hirschi.ag",
    phone: "123456789",
    partnermanager: "Urs Hirschi",
    contactPerson: "Stefan Hirschi",
    emailContactPerson: "stefan@hirschi.ag",
    phoneContactPerson: "9887654432",
    crm: "crmHirschi",
    level: "XYZ"
  });

  assert.ok(/^\/companies\/\d+$/.test(currentURL()));
  assert.equal(editPage.profileData.name, "Hirschi AG");
  assert.equal(editPage.profileData.web, "www.hirschi.ag");
  assert.equal(editPage.profileData.email, "info@hirschi.ag");
  assert.equal(editPage.profileData.phone, "123456789");
  assert.equal(editPage.profileData.partnermanager, "Urs Hirschi");
  assert.equal(editPage.profileData.contactPerson, "Stefan Hirschi");
  assert.equal(editPage.profileData.emailContactPerson, "stefan@hirschi.ag");
  assert.equal(editPage.profileData.phoneContactPerson, "9887654432");
  assert.equal(editPage.profileData.crm, "crmHirschi");
  assert.equal(editPage.profileData.level, "XYZ");
  assert.equal(editPage.profileData.locations, "Unterägeri");
  assert.equal(editPage.profileData.employeeQuantity1Category, "Diener");
  assert.equal(editPage.profileData.employeeQuantity1Quantity, "42");
});
