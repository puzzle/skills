import { test, skip } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';

import page from 'frontend/tests/pages/people-new';

moduleForAcceptance('Acceptance | create person');

test('creating a new person', async function(assert) {
  assert.expect(2);

  authenticateSession(this.application);

  await page.visit();

  assert.equal(currentURL(), '/people/new');

  await page.createPerson({
    name: 'Hansjoggeli',
    title: 'Dr.',
    role: 'Gigu',
    birthdate: new Date('2017-05-12'),
    origin: 'Schwiz',
    location: 'Chehrplatz Schwandi',
    language: 'Schwizerdütsch',
    maritalStatus: 'Ledig',
    status: 2
  });

  assert.equal(currentURL(), '/people/6');
});

skip('creating an empty new person', async function(assert) {
  assert.expect(2);

  authenticateSession(this.application);

  await page.visit();

  assert.equal(currentURL(), '/people/new');

  await page.createPerson({});

  assert.equal(currentURL(), '/people/new');
  // TODO expect errors!
});
