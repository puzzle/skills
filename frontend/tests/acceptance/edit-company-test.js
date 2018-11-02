import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

import applicationPage from 'frontend/tests/pages/application';
import page from 'frontend/tests/pages/company-edit';

moduleForAcceptance('Acceptance | edit company', {
  beforeEach() {
    authenticateSession(this.application, {
      ldap_uid: 'development_user',
      token: '1234'
    });
  }
});

test('/company/:id edit company data', async function(assert) {
  assert.expect(10);

  await applicationPage.visitCompanies('/companies');
  await applicationPage.companiesMenuItem('Firma');

  await page.toggleEditForm();
  await page.editForm.name('FirmaXYZ');
  await page.editForm.web('www.xyz.xyz');
  await page.editForm.email('xyz@xyz.xyz');
  await page.editForm.phone('1234567890');
  await page.editForm.partnermanager('Roger Müller');
  await page.editForm.contactPerson('Peter Müller');
  await page.editForm.emailContactPerson('pmueller@xyz.xyz');
  await page.editForm.phoneContactPerson('23475788273785423');
  await page.editForm.crm('crmXYZ');
  await page.editForm.level('Z');
  await page.editForm.submit();

  assert.equal(page.profileData.name, 'FirmaXYZ');
  assert.equal(page.profileData.web, 'www.xyz.xyz');
  assert.equal(page.profileData.email, 'xyz@xyz.xyz');
  assert.equal(page.profileData.phone, '1234567890');
  assert.equal(page.profileData.partnermanager, 'Roger Müller');
  assert.equal(page.profileData.contactPerson, 'Peter Müller');
  assert.equal(page.profileData.emailContactPerson, 'pmueller@xyz.xyz');
  assert.equal(page.profileData.phoneContactPerson, '23475788273785423');
  assert.equal(page.profileData.crm, 'crmXYZ');
  assert.equal(page.profileData.level, 'Z');

});
