import { module, skip, test } from "qunit";
import page from "frontend/tests/pages/people-new";
import { Interactor as Pikaday } from "ember-pikaday/test-support";
import { click, currentURL } from "@ember/test-helpers";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { selectChoose } from "ember-power-select/test-support";
import Notify from "ember-notify";
import { setLocale } from "ember-intl/test-support";

module("Acceptance | test person-form", function(hooks) {
  setupApplicationTest(hooks);

  const notifyStub = Notify.extend({
    alert(message, options) {
      options.closeAfter = null;
      return this.show("alert", message, options);
    }
  });
  /// Skip this test since there is a bug wtih the @renderInPlace attribute  of the powerselect
  // But if you remove the attribute the selects don't work properly while in test mode
  // The reason why it doesn't work as intended is highly likely due to the async behavior
  skip("creating a new person", async function(assert) {
    assert.expect(17);
    setLocale("en");
    // Visits person/new
    await page.newPersonPage.visit();
    assert.equal(currentURL(), "/people/new");

    // Selection for all the power selects
    /* eslint "no-undef": "off" */
    await page.newPersonPage.newRoleButton();
    await selectChoose("#personRole-role", "First Lieutenant");
    await selectChoose("#personRole-level", "S1");
    await page.newForm.rolePercent("20");

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
    assert.equal(page.profileData.role, "First Lieutenant S1 20%");
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

  // Skip this test since there is a bug wtih the @renderInPlace attribute  of the powerselect
  // But if you remove the attribute the selects don't work properly while in test mode
  // The reason why it doesn't work as intended is highly likely due to the async behavior
  skip("should display two errors when email is empty", async function(assert) {
    this.owner.unregister("service:notify");
    this.owner.register("service:notify", notifyStub);
    await page.newPersonPage.visit();
    assert.equal(currentURL(), "/people/new");

    await page.newForm.name("Findus");
    await page.newForm.title("Sofware Developer");
    await page.newForm.shortname("FI");
    await page.newForm.location("Bern");

    await click(".birthdate_pikaday > input");

    await Pikaday.selectDate(new Date(2023, 1, 19));

    await selectChoose("#department", "/dev/one");
    await selectChoose("#company", "Firma");
    await selectChoose("#maritalStatus", ".ember-power-select-option", 0);
    await page.newForm.submit();
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

  // Skip this test since there is a bug wtih the @renderInPlace attribute  of the powerselect
  // But if you remove the attribute the selects don't work properly while in test mode
  // The reason why it doesn't work as intended is highly likely due to the async behavior
  skip("should display one error when email format is invalid", async function(assert) {
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

  // Skip this test since there is a bug wtih the @renderInPlace attribute  of the powerselect
  // But if you remove the attribute the selects don't work properly while in test mode
  // The reason why it doesn't work as intended is highly likely due to the async behavior
  skip("/people/:id edit person data", async function(assert) {
    assert.expect(16);
    setLocale("en");

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");

    // Go into person-edit
    await page.visit({ person_id: 1 });
    await page.toggleEditForm();

    // Selection for all the power selects
    /* eslint "no-undef": "off" */
    await selectChoose("#personRole-role", "First Lieutenant");
    await selectChoose("#personRole-level", "S1");
    await page.editForm.rolePercent("20");
    await selectChoose("#department", "/bbt");

    await selectChoose("#company", "Firma");
    await selectChoose("#nationality", "Samoa");
    await selectChoose("#maritalStatus", "verheiratet");

    await click(".birthdate_pikaday > input");

    await Pikaday.selectDate(new Date(1970, 1, 19));

    // Testing if pikaday got the right dates

    assert.equal(Pikaday.selectedDay(), 19);
    assert.equal(Pikaday.selectedMonth(), 1);
    assert.equal(Pikaday.selectedYear(), 1970);
    // Fill out the persons text fields
    await page.editForm.name("Hansjoggeli");
    await page.editForm.email("hansjoggeli@example.com");
    await page.editForm.shortname("hj");
    await page.editForm.title("Dr.");
    await page.editForm.location("Chehrplatz Schwandi");

    // Submit the edited content
    await page.editForm.submit();
    // Assert that all we changed is present

    assert.equal(page.profileData.name, "Hansjoggeli");
    assert.equal(page.profileData.email, "hansjoggeli@example.com");
    assert.equal(page.profileData.shortname, "hj");
    assert.equal(page.profileData.title, "Dr.");
    assert.equal(page.profileData.role, "First Lieutenant S1 20%");
    assert.equal(page.profileData.department, "/bbt");
    assert.equal(page.profileData.company, "Firma");
    assert.equal(page.profileData.birthdate, "19.02.1970");
    assert.equal(page.profileData.nationalities, "Samoa");
    assert.equal(page.profileData.location, "Chehrplatz Schwandi");
    assert.equal(page.profileData.maritalStatus, "verheiratet");
    // Toggle Edit again
    await page.toggleEditForm();
    // Enable two Nationalities

    await page.toggleNationalitiesCheckbox();
    // Select the second nationality
    await selectChoose("#nationality2", ".ember-power-select-option", 2);
    // Submit it
    await page.editForm.submit();

    // Assert that it is there
    assert.equal(page.profileData.nationalities, "Samoa, Åland");
    // go into edit again
    await page.toggleEditForm();

    // Toggle the second nationality option off
    await page.toggleNationalitiesCheckbox();

    // Submit it
    await page.editForm.submit();
    // Check that the second nationality is gone
    assert.equal(page.profileData.nationalities, "Samoa");
  });

  test("/people/:id abort with escape", async function(assert) {
    assert.expect(1);
    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    await page.toggleEditForm();

    await triggerKeyUp("Escape");

    // Testing if the header of competence-show is there, stherefore profing we're in show
    assert.equal(
      $("#competence-show-header").attr("class"),
      "card-header bg-info"
    );
  });

  // Skip this test since there is a bug wtih the @renderInPlace attribute  of the powerselect
  // But if you remove the attribute the selects don't work properly while in test mode
  // The reason why it doesn't work as intended is highly likely due to the async behavior
  skip("/people/:id edit person competences", async function(assert) {
    assert.expect(6);

    await applicationPage.visitHome("/");
    await selectChoose("#people-search", "Arya Stark");

    await page.competences.toggleForm();
    await fillIn(
      "textarea",
      "Competence 1\n" + "\n" + "Competence 2\n" + "Competence 3\n"
    );
    await page.competences.submit();
    assert.equal(page.competences.list().count, 5);
    assert.equal(page.competences.list(0).text, "Competence 1");
    assert.equal(page.competences.list(1).text, "");
    assert.equal(page.competences.list(2).text, "Competence 2");
    assert.equal(page.competences.list(3).text, "Competence 3");
    assert.equal(page.competences.list(4).text, "");
  });
});
