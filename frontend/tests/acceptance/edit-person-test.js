import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

import applicationPage from 'frontend/tests/pages/application';
import page from 'frontend/tests/pages/person-edit';

moduleForAcceptance('Acceptance | edit person', {
  beforeEach() {
    authenticateSession(this.application, {
      ldap_uid: 'development_user',
      token: '1234'
    });
  }
});

test('/people/:id edit person data', async function(assert) {
  assert.expect(7);

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

test('Creating a new variation', async function(assert) {
  assert.expect(12);

  await applicationPage.visitHome('/');
  await applicationPage.menuItem('Bob Anderson');

  assert.ok(page.personActions.originCVIsActive);

  const originURL = currentURL();

  await page.createVariation('Dönu.js');

  assert.equal(page.personActions.variationDropdownButtonText, 'Dönu.js');
  assert.ok(page.personActions.variationDropdownButtonIsActive);
  assert.notOk(page.personActions.originCVIsActive);

  assert.notEqual(currentURL(), originURL);

  assert.equal(page.profileData.name, 'Bob Anderson');
  assert.equal(page.profileData.title, 'BSc in Cleaning');
  assert.equal(page.profileData.role, 'Cleaner');
  //assert.equal(page.profileData.birthdate, '02.03.2014');
  assert.equal(page.profileData.origin, 'Switzerland');
  assert.equal(page.profileData.location, 'Bern');
  assert.equal(page.profileData.maritalStatus, 'Single');
  assert.equal(page.profileData.status, 'Mitarbeiter');
});
