import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import applicationPage from 'frontend/tests/pages/application';
import page from 'frontend/tests/pages/person-skills';

moduleForAcceptance('Acceptance | create peopleSkill');

test('creating a new peopleSkill', async function(assert) {
  assert.expect(3);

  authenticateSession(this.application, {
    ldap_uid: 'development_user',
    token: '1234'
  });

  // Go to the start page and select a user from the dropdown
  await applicationPage.visitHome('/');
  await selectChoose('#people-search', '.ember-power-select-option', 0);

  // Visits person/:id/skills
  await page.visit({ person_id: /\d+$/.exec(currentURL()) })

  // Selection for all the power selects
  /* eslint "no-undef": "off" */
  await page.newPeopleSkillModal.openModalButton();
  await selectChoose('#people-skill-new-skill', 'Bash');
  await selectChoose('#people-skill-new-level', '3');
  await selectChoose('#people-skill-new-interest', '2');
  await page.newPeopleSkillModal.certificateToggle();

  await page.newPeopleSkillModal.createPeopleSkill({});
  //await new Promise(resolve => setTimeout(resolve, 2000));

  let names = page.peopleSkillsTable.skillNames.toArray().map(name => name.text)
  assert.ok(names.includes('Bash'));
  let levels = page.peopleSkillsTable.levels.toArray().map(name => name.text)
  assert.ok(levels.includes('3'));
  let interests = page.peopleSkillsTable.interests.toArray().map(name => name.text)
  assert.ok(interests.includes('2'));
});
