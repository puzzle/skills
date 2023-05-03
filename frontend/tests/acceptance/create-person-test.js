import { module, test, skip } from "qunit";
import page from "frontend/tests/pages/people-new";
import { Interactor as Pikaday } from "ember-pikaday/test-support";
import { click, currentURL } from "@ember/test-helpers";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { selectChoose } from "ember-power-select/test-support";
import Notify from "ember-notify";
import { setLocale } from "ember-intl/test-support";

module("Acceptance | create person", function(hooks) {
  setupApplicationTest(hooks);

  const notifyStub = Notify.extend({
    alert(message, options) {
      options.closeAfter = null;
      return this.show("alert", message, options);
    }
  });
  /* Currently we are skipping this test since it works locally but fails on
   our Travis Server (Seemingly due to some failing page loads). Optimally you
   would run this test locally but put it back on skip when pushing to Github */
  test("creating a new person", async function(assert) {
    assert.expect(13);
    setLocale("en");
    // Visits person/new
    await page.newPersonPage.visit();
    assert.equal(currentURL(), "/people/new");

    // Selection for all the power selects
    /* eslint "no-undef": "off" */
    await page.newPersonPage.newRoleButton();
    await selectChoose(".role-dropdown", ".ember-power-select-option", 0);
    await selectChoose(".level-dropdown", "S3");

    await selectChoose("#department", "/dev/ruby");
    await selectChoose("#company", "Firma");
    await selectChoose("#nationality", ".ember-power-select-option", 0);
    await selectChoose("#maritalStatus", "verheiratet");

    await click(".birthdate_pikaday > input");
    // Cant be more/less than +/- 10 Years from today
    await Pikaday.selectDate(new Date(2019, 1, 19));

    // Testing if pikaday got the right dates
    assert.equal(Pikaday.selectedDay(), 19);
    assert.equal(Pikaday.selectedMonth(), 1);
    assert.equal(Pikaday.selectedYear(), 2019);

    // Filling out the text fields
    await page.newForm.name("Dolores");
    await page.newForm.email("dolores@example.com");
    await page.newForm.title("Dr.");
    await page.newForm.rolePercent("20");
    await page.newForm.location("Westworld");
    await page.newForm.shortname("DD");

    await page.newPersonPage.submit();

    // Current Url now should be "people/d+" where d+ = any amount of numbers (like an id)
    assert.ok(/^\/people\/\d+$/.test(currentURL()));

    // Assert that all we entered above actually made it into the profile correctly
    assert.equal(page.profileData.name, "Dolores");
    assert.equal(page.profileData.email, "dolores@example.com");
    assert.equal(page.profileData.shortname, "DD");
    assert.equal(page.profileData.title, "Dr.");
    assert.equal(page.profileData.role, "Software-Engineer");
    assert.equal(page.profileData.department, "/dev/ruby");
    assert.equal(page.profileData.company, "Firma");
    assert.equal(page.profileData.birthdate, "19.02.2019");
    assert.equal(page.profileData.nationalities, "Afghanistan");
    assert.equal(page.profileData.location, "Westworld");
    assert.equal(page.profileData.maritalStatus, "verheiratet");
    assert.ok(["DE", "EN", "FR"].includes(page.profileData.language[0]));
  });

  test("creating an empty new person", async function(assert) {
    assert.expect(2);

    await page.newPersonPage.visit();

    assert.equal(currentURL(), "/people/new");

    await page.newPersonPage.createPerson({});

    assert.equal(currentURL(), "/people/new");
    // TODO expect errors!
  });

  //Skip this test since there is a bug, most likely from the pikaday addon,
  // which prevent the test from working as expected
  test("should display two errors when email is empty", async function(assert) {
    this.owner.unregister("service:notify");
    this.owner.register("service:notify", notifyStub);
    await page.newPersonPage.visit();
    assert.equal(currentURL(), "/people/new");

    await page.newForm.name("Findus");
    await page.newForm.title("Sofware Developer");
    await page.newForm.shortname("FI");
    await page.newForm.location("Bern");

    await click(".birthdate_pikaday > input");
    // Cant be more/less than +/- 10 Years from today
    await Pikaday.selectDate(new Date(1970, 1, 19));

    await selectChoose("#department", "/dev/one");
    await selectChoose("#company", "Firma");
    await selectChoose("#maritalStatus", ".ember-power-select-option", 0);

    await click("button#submit-button");
    assert.equal(
      document.querySelectorAll(".ember-notify")[0].querySelector(".message")
        .innerText,
      "Email muss ausgefüllt werden"
    );
    assert.equal(
      document.querySelectorAll(".ember-notify")[1].querySelector(".message")
        .innerText,
      "Email Format nicht gültig"
    );
  });

  test("should display one error when email format is invalid", async function(assert) {
    this.owner.unregister("service:notify");
    this.owner.register("service:notify", notifyStub);
    await page.newPersonPage.visit();
    assert.equal(currentURL(), "/people/new");

    page.newPersonPage.toggleNewForm();

    await page.newForm.name("Findus");
    await page.newForm.email("findus.puzzle");
    await page.newForm.title("Sofware Developer");
    await page.newForm.shortname("FI");
    await page.newForm.location("Bern");

    await click(".birthdate_pikaday > input");

    // Cant be more/less than +/- 10 Years from today
    await Pikaday.selectDate(new Date(2019, 1, 19));

    await selectChoose("#department", ".ember-power-select-option", 0);
    await selectChoose("#company", ".ember-power-select-option", 0);
    await selectChoose("#maritalStatus", ".ember-power-select-option", 0);

    await page.newPersonPage.submit();
    assert.equal(
      document.querySelector(".ember-notify .message").innerText,
      "Email Format nicht gültig"
    );
  });
});
