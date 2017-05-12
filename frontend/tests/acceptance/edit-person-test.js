import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

import page from 'frontend/tests/pages/person-edit';

moduleForAcceptance('Acceptance | edit person');

test('/people/:id edit person data', async function(assert) {
  assert.expect(9);

  authenticateSession(this.application);

  await visit('/people/5');

  assert.equal(currentURL(), '/people/5');

  await page.toggleEditForm()
    .editForm
    .name('Hansjoggeli')
    .title('Dr.')
    .role('Joggeli')
    //.birthdate('12.05.2017')
    .origin('Schwiz')
    .location('Chehrplatz Schwandi')
    .maritalStatus('Verwittwet')
    .status(3)
    .submit();

  assert.equal(currentURL(), '/people/5');
  assert.equal(page.profileData.name, 'Hansjoggeli');
  assert.equal(page.profileData.title, 'Dr.');
  assert.equal(page.profileData.role, 'Joggeli');
  //assert.equal(page.profileData.birthdate, '12.05.2017');
  assert.equal(page.profileData.origin, 'Schwiz');
  assert.equal(page.profileData.location, 'Chehrplatz Schwandi');
  assert.equal(page.profileData.maritalStatus, 'Verwittwet');
  assert.equal(page.profileData.status, 'Bewerber');
});
