import { test, skip } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';

import page from 'frontend/tests/pages/login';

moduleForAcceptance('Acceptance | login');

skip('login with valid credentials works', async function(assert) {
  await page.visit();

  // Need data to an actual valid user in fixtures..
  // As I see it, login only works through ldap for now..
  await page.login('gief valid user', '123456');

  assert.equal(currentURL(), '/people');
});

test('login with invalid credentials rejects', async function(assert) {
  await page.visit();
  await page.login('habasch', '123456');

  assert.equal(currentURL(), '/login');
});
