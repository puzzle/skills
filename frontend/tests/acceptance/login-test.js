import Service from '@ember/service';
import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';

import page from 'frontend/tests/pages/login';

moduleForAcceptance('Acceptance | login');

test('login with valid credentials works', async function(assert) {
  await page.visit();

  // Need data to an actual valid user in fixtures..
  // As I see it, login only works through ldap for now..
  await page.login('ken', 'password');

  assert.equal(currentURL(), '/people');
});

test('login with invalid credentials rejects', async function(assert) {
  assert.expect(2);

  this.application.register('service:mocknotify', Service.extend({
    alert(message) {
      // Currently no real message from the backend as LDAP is not available
      // and thus errors with a status code of 500
      assert.equal(message, 'Ungültige Login Daten');
    }
  }));
  this.application.inject('route', 'notify', 'service:mocknotify');

  await page.visit();

  await page.login('habasch', '123456');

  assert.equal(currentURL(), '/login');
});
