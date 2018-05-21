import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

import page from 'frontend/tests/pages/people-new';
import editPage from 'frontend/tests/pages/person-edit';

moduleForAcceptance('Acceptance | create person');

test('creating a new person', async function(assert) {
  assert.expect(11);

  authenticateSession(this.application, {
    ldap_uid: 'development_user',
    token: '1234'
  });

  await page.visit();

  assert.equal(currentURL(), '/people/new');

  await page.createPerson({
    name: 'Hansjoggeli',
    title: 'Dr.',
    role: 'Gigu',
    birthdate: '12.05.2017',
    origin: 'Schwiz',
    location: 'Chehrplatz Schwandi',
    language: 'Schwizerdütsch',
    maritalStatus: 'Ledig',
  });

  assert.ok(/^\/people\/\d+$/.test(currentURL()));
  assert.equal(editPage.profileData.name, 'Hansjoggeli');
  assert.equal(editPage.profileData.title, 'Dr.');
  assert.equal(editPage.profileData.role, 'Gigu');
  assert.equal(editPage.profileData.birthdate, '12.05.2017');
  assert.equal(editPage.profileData.origin, 'Schwiz');
  assert.equal(editPage.profileData.location, 'Chehrplatz Schwandi');
  assert.equal(editPage.profileData.language, 'Schwizerdütsch');
  assert.equal(editPage.profileData.maritalStatus, 'Ledig');
});

test('creating an empty new person', async function(assert) {
  assert.expect(2);

  authenticateSession(this.application);

  await page.visit();

  assert.equal(currentURL(), '/people/new');

  await page.createPerson({});

  assert.equal(currentURL(), '/people/new');
  // TODO expect errors!
});
