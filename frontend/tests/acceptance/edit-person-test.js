import { module, test } from "qunit";
import applicationPage from "frontend/tests/pages/application";
import page from "frontend/tests/pages/person-edit";
import { triggerKeyUp } from "ember-keyboard";
import { Interactor as Pikaday } from "ember-pikaday/test-support";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { selectChoose } from "ember-power-select/test-support";
import { click, fillIn, pauseTest } from "@ember/test-helpers";
import { setLocale } from "ember-intl/test-support";

module("Acceptance | edit person", function(hooks) {
  setupApplicationTest(hooks);

  //Skip this test since there is a bug, most likely from the pikaday addon,
  // which prevent the test from working as expected
  test("/people/:id edit person data", async function(assert) {
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

    // await page.toggleNationalities();
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

  test("/people/:id edit person competences", async function(assert) {
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
