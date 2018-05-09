import { skip } from 'qunit';
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

skip('/people/:id edit person data', async function(assert) {
  assert.expect(7);

  await applicationPage.visitHome('/');
  await applicationPage.peopleMenuItem('Bob Anderson');

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

  assert.equal(page.profileData.name, 'Hansjoggeli');
  assert.equal(page.profileData.title, 'Dr.');
  assert.equal(page.profileData.role, 'Joggeli');
  //assert.equal(page.profileData.birthdate, '12.05.2017');
  assert.equal(page.profileData.origin, 'Schwiz');
  assert.equal(page.profileData.location, 'Chehrplatz Schwandi');
  assert.equal(page.profileData.maritalStatus, 'Verwittwet');
  assert.equal(page.profileData.status, 'Bewerber');
});

skip('/people/:id edit person competences', async function(assert) {
  assert.expect(4);

  await applicationPage.visitHome('/');
  await applicationPage.peopleMenuItem('Bob Anderson');

  await page.competences.toggleForm();
  await page.competences.textarea(
    '\n' +
    'Competence 1\n' +
    '\n' +
    'Competence 2\n' +
    'Competence 3\n' +
    '\n' +
    '\n'
  );
  await page.competences.submit();

  assert.equal(page.competences.list().count, 3);
  assert.equal(page.competences.list(0).text, 'Competence 1');
  assert.equal(page.competences.list(1).text, 'Competence 2');
  assert.equal(page.competences.list(2).text, 'Competence 3');
});

skip('Creating a new variation', async function(assert) {
  assert.expect(12);

  await applicationPage.visitHome('/');
  await applicationPage.peopleMenuItem('Bob Anderson');

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
