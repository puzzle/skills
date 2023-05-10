import { module, skip, test } from "qunit";
import createPage from "frontend/tests/pages/people-new";
import editPage from "frontend/tests/pages/person-edit";
import { Interactor as Pikaday } from "ember-pikaday/test-support";
import { click, currentURL, fillIn } from "@ember/test-helpers";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { selectChoose } from "ember-power-select/test-support";
import Notify from "ember-notify";
import { setLocale } from "ember-intl/test-support";
import applicationPage from "./../pages/application";
import { triggerKeyUp } from "ember-keyboard";

module("Acceptance | Test person-form", function(hooks) {
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
    await createPage.newPersonPage.visit();
    assert.equal(currentURL(), "/people/new");

    // Selection for all the power selects
    /* eslint "no-undef": "off" */
    await createPage.newPersonPage.newRoleButton();
    await selectChoose("#personRole-role", "First Lieutenant");
    await selectChoose("#personRole-level", "S1");
    await createPage.newForm.rolePercent("20");

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
    await createPage.newForm.name("Dolores");
    await createPage.newForm.email("dolores@example.com");
    await createPage.newForm.title("Dr.");
    await createPage.newForm.rolePercent("20");
    await createPage.newForm.location("Westworld");
    await createPage.newForm.shortname("DD");

    await createPage.newPersonPage.submit();

    // Current Url now should be "people/d+" where d+ = any amount of numbers (like an id)
    assert.ok(/^\/people\/\d+$/.test(currentURL()));

    // Assert that all we entered above actually made it into the profile correctly
    assert.equal(createPage.profileData.name, "Dolores");
    assert.equal(createPage.profileData.email, "dolores@example.com");
    assert.equal(createPage.profileData.shortname, "DD");
    assert.equal(createPage.profileData.title, "Dr.");
    assert.equal(createPage.profileData.role, "First Lieutenant S1 20%");
    assert.equal(createPage.profileData.department, "/dev/ruby");
    assert.equal(createPage.profileData.company, "Firma");
    assert.equal(createPage.profileData.birthdate, "19.02.2019");
    assert.equal(createPage.profileData.nationalities, "Afghanistan");
    assert.equal(createPage.profileData.location, "Westworld");
    assert.equal(createPage.profileData.maritalStatus, "verheiratet");
    assert.ok(["DE", "EN", "FR"].includes(createPage.profileData.language[0]));
  });

  test("creating an empty new person", async function(assert) {
    assert.expect(2);

    await createPage.newPersonPage.visit();

    assert.equal(currentURL(), "/people/new");

    await createPage.newPersonPage.createPerson({});

    assert.equal(currentURL(), "/people/new");
    // TODO expect errors!
  });

  // Skip this test since there is a bug wtih the @renderInPlace attribute  of the powerselect
  // But if you remove the attribute the selects don't work properly while in test mode
  // The reason why it doesn't work as intended is highly likely due to the async behavior
  skip("should display two errors when email is empty", async function(assert) {
    this.owner.unregister("service:notify");
    this.owner.register("service:notify", notifyStub);
    await createPage.newPersonPage.visit();
    assert.equal(currentURL(), "/people/new");

    await createPage.newForm.name("Findus");
    await createPage.newForm.title("Sofware Developer");
    await createPage.newForm.shortname("FI");
    await createPage.newForm.location("Bern");

    await click(".birthdate_pikaday > input");

    await Pikaday.selectDate(new Date(2023, 1, 19));

    await selectChoose("#department", "/dev/one");
    await selectChoose("#company", "Firma");
    await selectChoose("#maritalStatus", ".ember-power-select-option", 0);
    await createPage.newForm.submit();
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
    await createPage.newPersonPage.visit();
    assert.equal(currentURL(), "/people/new");

    createPage.newPersonPage.toggleNewForm();

    await createPage.newForm.name("Findus");
    await createPage.newForm.email("findus.puzzle");
    await createPage.newForm.title("Sofware Developer");
    await createPage.newForm.shortname("FI");
    await createPage.newForm.location("Bern");

    await click(".birthdate_pikaday > input");

    // Cant be more/less than +/- 10 Years from today
    await Pikaday.selectDate(new Date(2019, 1, 19));

    await selectChoose("#department", ".ember-power-select-option", 0);
    await selectChoose("#company", ".ember-power-select-option", 0);
    await selectChoose("#maritalStatus", ".ember-power-select-option", 0);

    await createPage.newPersonPage.submit();
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

    // Go to the start createPage and select a user from the dropdown
    await applicationPage.visitHome("/");

    // Go into person-edit
    await createPage.visit({ person_id: 1 });
    await createPage.toggleEditForm();

    // Selection for all the power selects
    /* eslint "no-undef": "off" */
    await selectChoose("#personRole-role", "First Lieutenant");
    await selectChoose("#personRole-level", "S1");
    await createPage.editForm.rolePercent("20");
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
    await createPage.editForm.name("Hansjoggeli");
    await createPage.editForm.email("hansjoggeli@example.com");
    await createPage.editForm.shortname("hj");
    await createPage.editForm.title("Dr.");
    await createPage.editForm.location("Chehrplatz Schwandi");

    // Submit the edited content
    await createPage.editForm.submit();
    // Assert that all we changed is present

    assert.equal(createPage.profileData.name, "Hansjoggeli");
    assert.equal(createPage.profileData.email, "hansjoggeli@example.com");
    assert.equal(createPage.profileData.shortname, "hj");
    assert.equal(createPage.profileData.title, "Dr.");
    assert.equal(createPage.profileData.role, "First Lieutenant S1 20%");
    assert.equal(createPage.profileData.department, "/bbt");
    assert.equal(createPage.profileData.company, "Firma");
    assert.equal(createPage.profileData.birthdate, "19.02.1970");
    assert.equal(createPage.profileData.nationalities, "Samoa");
    assert.equal(createPage.profileData.location, "Chehrplatz Schwandi");
    assert.equal(createPage.profileData.maritalStatus, "verheiratet");
    // Toggle Edit again
    await createPage.toggleEditForm();
    // Enable two Nationalities

    await createPage.toggleNationalitiesCheckbox();
    // Select the second nationality
    await selectChoose("#nationality2", ".ember-power-select-option", 2);
    // Submit it
    await createPage.editForm.submit();

    // Assert that it is there
    assert.equal(createPage.profileData.nationalities, "Samoa, Åland");
    // go into edit again
    await createPage.toggleEditForm();

    // Toggle the second nationality option off
    await createPage.toggleNationalitiesCheckbox();

    // Submit it
    await createPage.editForm.submit();
    // Check that the second nationality is gone
    assert.equal(createPage.profileData.nationalities, "Samoa");
  });

  test("/people/:id abort with escape", async function(assert) {
    assert.expect(1);
    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 0);
    await editPage.toggleEditForm();

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

    await createPage.competences.toggleForm();
    await fillIn(
      "textarea",
      "Competence 1\n" + "\n" + "Competence 2\n" + "Competence 3\n"
    );
    await createPage.competences.submit();
    assert.equal(createPage.competences.list().count, 5);
    assert.equal(createPage.competences.list(0).text, "Competence 1");
    assert.equal(createPage.competences.list(1).text, "");
    assert.equal(createPage.competences.list(2).text, "Competence 2");
    assert.equal(createPage.competences.list(3).text, "Competence 3");
    assert.equal(createPage.competences.list(4).text, "");
  });
});
