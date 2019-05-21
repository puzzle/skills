import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import page from 'frontend/tests/pages/skills-index';

moduleForAcceptance('Acceptance | show skill', {
  beforeEach() {
    authenticateSession(this.application, {
      ldap_uid: 'development_user',
      token: '1234'
    });
  }
});

test('shows Rails and its peopleSkills', async function(assert) {
  assert.expect(3);

  await page.indexPage.visit();

  assert.equal(currentURL(), '/skills');

  await page.indexPage.skills.skillNames.toArray()[0].clickOn()

  let names = page.indexPage.skillModal.personNames.toArray().map(name => name.text)
  assert.ok(names.includes('ken'))
  assert.ok(names.includes('Bob Anderson'))
});

test('shows JUnit and its peopleSkills', async function(assert) {
  assert.expect(2);

  await page.indexPage.visit();

  assert.equal(currentURL(), '/skills');

  await page.indexPage.skills.skillNames.toArray()[1].clickOn()

  let names = page.indexPage.skillModal.personNames.toArray().map(name => name.text)
  assert.ok(names.includes('ken'))
});
