import { module, test } from "qunit";
import applicationPage from "frontend/tests/pages/application";
import page from "frontend/tests/pages/person-skills";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { selectChoose } from "ember-power-select/test-support";
import { currentURL } from "@ember/test-helpers";

module("Acceptance | create people-skill", function(hooks) {
  setupApplicationTest(hooks);

  test("creating a new peopleSkill", async function(assert) {
    assert.expect(2);

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    // Visits person/:id/skills
    await page.visit({ person_id: /\d+$/.exec(currentURL()) });

    // Selection for all the power selects
    /* eslint "no-undef": "off" */
    await page.newPeopleSkillModal.openModalButton();
    await selectChoose("#people-skill-new-skill", "Bash");
    $(".people-skill-new-dropdowns .slider-tick:eq(2)").mousedown();
    await page.newPeopleSkillModal.levelButtons.objectAt(1).clickOn();
    await page.newPeopleSkillModal.interestButtons.objectAt(3).clickOn();
    await page.newPeopleSkillModal.certificateToggle();

    await page.newPeopleSkillModal.createPeopleSkill({});

    let names = page.peopleSkillsTable.skillNames
      .toArray()
      .map(name => name.text);
    assert.ok(names.includes("Bash"));

    let levels = page.peopleSkillsTable.levels.toArray().map(name => name.text);
    assert.ok(levels.includes("Trainee 1"));
  });

  test("checks if the skill titles are listed alphabetically and case-insensitive", async function(assert) {
    assert.expect(5);

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 1);

    // Visits person/:id/skills
    await page.visit({ person_id: /\d+$/.exec(currentURL()) });

    // Open the modal and subsequently open the skill dropdown
    /* eslint "no-undef": "off" */
    await page.newPeopleSkillModal.openModalButton();
    await page.newPeopleSkillModal.openSkillTitleDropdown();

    // Map all the available skills in the dropdown to an array
    let titles = page.newPeopleSkillModal.skillTitleDropdownOptions
      .toArray()
      .map(title => title.text);

    assert.equal(titles[0], "");
    assert.equal(titles[1], "Bash");
    assert.equal(titles[2], "cunit");
    assert.equal(titles[3], "ember");
    assert.equal(titles[4], "JUnit");
  });
});
