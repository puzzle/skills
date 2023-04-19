import { module, test, skip } from "qunit";
import applicationPage from "frontend/tests/pages/application";
import page from "frontend/tests/pages/person-edit";
import { triggerKeyUp } from "ember-keyboard";
import { Interactor as Pikaday } from "ember-pikaday/test-support";
import $ from "jquery";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { selectChoose } from "ember-power-select/test-support";
import { click, fillIn } from "@ember/test-helpers";

module("Acceptance | edit person", function(hooks) {
  setupApplicationTest(hooks);

  skip("/people/:id edit person data", async function(assert) {
    assert.expect(16);

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    // Go into person-edit
    await page.toggleEditForm();

    // Selection for all the power selects
    /* eslint "no-undef": "off" */
    await selectChoose(".role-dropdown", "Captain");
    await selectChoose(".level-dropdown", "S3");
    await page.editForm.rolePercent("20");

    await selectChoose("#department", "/dev/one");
    await selectChoose("#company", "Firma");
    await selectChoose("#nationality", "Samoa");
    await selectChoose("#maritalStatus", "verheiratet");

    // interactor is the interactable object for the pikaday-datepicker
    await click(".birthdate_pikaday > input");
    await Pikaday.selectDate(new Date(2019, 1, 19));

    // Testing if pikaday got the right dates
    assert.equal(interactor.selectedDay(), 19);
    assert.equal(interactor.selectedMonth(), 1);
    assert.equal(interactor.selectedYear(), 2019);

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
    assert.equal(page.profileData.role, "Captain S3 20%");
    assert.equal(page.profileData.department, "/dev/one");
    assert.equal(page.profileData.company, "Firma");
    assert.equal(page.profileData.birthdate, "19.02.2019");
    assert.equal(page.profileData.nationalities, "Samoa");
    assert.equal(page.profileData.location, "Chehrplatz Schwandi");
    assert.equal(page.profileData.maritalStatus, "verheiratet");

    // Toggle Edit again
    await page.toggleEditForm();

    // Enable two Nationalities
    await page.toggleNationalities();

    // Select the second nationality
    await selectChoose("#nationality2", "Schweiz");

    // Submit it
    await page.editForm.submit();

    // Assert that it is there
    assert.equal(page.profileData.nationalities, "Samoa, Schweiz");

    // go into edit again
    await page.toggleEditForm();

    // Toggle the second nationality option off
    await page.toggleNationalities();

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

  test("/people/:id edit person competences", async function(assert) {
    assert.expect(6);

    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 0);

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
