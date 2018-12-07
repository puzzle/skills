import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import { setFlatpickrDate } from 'ember-flatpickr/test-support/helpers';
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
  await selectChoose('#people-search', '.ember-power-select-option', 0);

  await page.toggleEditForm();

  /* eslint "no-undef": "off" */
  await selectChoose('#role', '.ember-power-select-option', 0)
  await selectChoose('#company', 'Firma');
  await selectChoose('#nationality', "Samoa");
  await selectChoose('#martialStatus', 'verheiratet');

  setFlatpickrDate('.flatpickr-input', '26.10.2018')

  await page.editForm.name('Hansjoggeli');
  await page.editForm.title('Dr.');
  await page.editForm.location('Chehrplatz Schwandi');
  await page.editForm.submit();

  assert.equal(page.profileData.name, 'Hansjoggeli');
  assert.equal(page.profileData.title, 'Dr.');
  assert.equal(page.profileData.role, 'System-Engineer');
  assert.equal(page.profileData.nationalities, 'Samoa');
  assert.equal(page.profileData.location, 'Chehrplatz Schwandi');

  await page.toggleEditForm();
  await page.toggleNationalities();
  await selectChoose('#nationality2', "Schweiz");
  await page.editForm.submit();
  assert.equal(page.profileData.nationalities, 'Samoa , Schweiz')
  await page.toggleEditForm();
  await page.toggleNationalities();
  await page.editForm.submit();
  assert.equal(page.profileData.nationalities, 'Samoa')


});

test('/people/:id edit person competences', async function(assert) {
  assert.expect(4);

  await applicationPage.visitHome('/');
  await selectChoose('#people-search', '.ember-power-select-option', 0);

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
