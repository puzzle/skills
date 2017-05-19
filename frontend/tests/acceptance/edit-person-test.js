import { test, skip } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

import applicationPage from 'frontend/tests/pages/application';
import page from 'frontend/tests/pages/person-edit';

moduleForAcceptance('Acceptance | edit person');

test('/people/:id edit person data', async function(assert) {
  assert.expect(7);

  authenticateSession(this.application, {
    ldap_uid: 'development_user',
    token: '1234'
  });

  await applicationPage.visitHome('/');
  await applicationPage.menuItem('Bob Anderson');

  await page.toggleEditForm();
  await page.editForm.name('Hansjoggeli');
  await page.editForm.title('Dr.');
  await page.editForm.role('Joggeli');
  await page.editForm.birthdate('12.05.2017');
  await page.editForm.origin('Schwiz');
  await page.editForm.location('Chehrplatz Schwandi');
  await page.editForm.maritalStatus('Verwittwet');
  await page.editForm.status(3);
  await page.editForm.submit();

  await andThen(() => {
    assert.equal(page.profileData.name, 'Hansjoggeli');
    assert.equal(page.profileData.title, 'Dr.');
    assert.equal(page.profileData.role, 'Joggeli');
    //assert.equal(page.profileData.birthdate, '12.05.2017');
    assert.equal(page.profileData.origin, 'Schwiz');
    assert.equal(page.profileData.location, 'Chehrplatz Schwandi');
    assert.equal(page.profileData.maritalStatus, 'Verwittwet');
    assert.equal(page.profileData.status, 'Bewerber');
  });
});

skip('Creating a new variation', async function(assert) {
  assert.expect(1);

  authenticateSession(this.application);

  await page.visit({ person_id: 5 });
  await page.createVariation('Dönu.js');

  assert.equal(currentURL(), '/people/6');
});
