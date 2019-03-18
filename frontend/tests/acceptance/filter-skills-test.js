import { test } from 'qunit';
import moduleForAcceptance from 'frontend/tests/helpers/module-for-acceptance';
import { authenticateSession } from 'frontend/tests/helpers/ember-simple-auth';
import page from 'frontend/tests/pages/skills-index';

moduleForAcceptance('Acceptance | filter skills', {
  beforeEach() {
    authenticateSession(this.application, {
      ldap_uid: 'development_user',
      token: '1234'
    });
  }
});

test('filters nothing and shows every skill', async function(assert) {
  assert.expect(4);


  await page.indexPage.visit();

  assert.equal(currentURL(), '/skills');

  let names = page.indexPage.skills.skillNames.toArray().map(name => name.text)
  assert.ok(names.includes('JUnit'))
  assert.ok(names.includes('Bash'))
  assert.ok(names.includes('Rails'))
});

test('filters only defaultSet by default', async function(assert) {
  assert.expect(5);


  await page.indexPage.visit();

  assert.equal(currentURL(), '/skills');

  await page.indexPage.defaultFilterButton();

  assert.equal(currentURL(), '/skills?defaultSet=true');
  let names = page.indexPage.skills.skillNames.toArray().map(name => name.text)
  assert.notOk(names.includes('JUnit'))
  assert.notOk(names.includes('Bash'))
  assert.ok(names.includes('Rails'))
});

test('filters only defaultSet by new', async function(assert) {
  assert.expect(5);


  await page.indexPage.visit();

  assert.equal(currentURL(), '/skills');

  await page.indexPage.newFilterButton();

  assert.equal(currentURL(), '/skills?defaultSet=new');
  let names = page.indexPage.skills.skillNames.toArray().map(name => name.text)
  assert.notOk(names.includes('JUnit'))
  assert.notOk(names.includes('Rails'))
  assert.ok(names.includes('Bash'))
});

test('filters only category by System-Engineering', async function(assert) {
  assert.expect(5);


  await page.indexPage.visit();

  assert.equal(currentURL(), '/skills');

  let store = this.owner.__container__.lookup('service:store')
  let allCategories = store.peekAll('category')
  await allCategories
  let filterCategory = allCategories.filterBy('title', 'System-Engineering')[0]
  /* eslint "no-undef": "off" */
  await selectChoose('#category-filter-dropdown', filterCategory.get('title'))

  assert.equal(currentURL(), '/skills?category=' + filterCategory.get('id'));

  let names = page.indexPage.skills.skillNames.toArray().map(name => name.text)

  assert.notOk(names.includes('JUnit'))
  assert.notOk(names.includes('Rails'))
  assert.ok(names.includes('Bash'))
});

test('filters category by Software-Engineering and defaultSet by true', async function(assert) {
  assert.expect(6);


  await page.indexPage.visit();

  assert.equal(currentURL(), '/skills');

  let store = this.owner.__container__.lookup('service:store')
  let allCategories = store.peekAll('category')
  await allCategories
  let filterCategory = allCategories.filterBy('title', 'Software-Engineering')[0]

  /* eslint "no-undef": "off" */
  await selectChoose('#category-filter-dropdown', filterCategory.get('title'))

  assert.equal(currentURL(), '/skills?category=' + filterCategory.get('id'));

  await page.indexPage.defaultFilterButton();

  assert.equal(currentURL(), '/skills?category=' + filterCategory.get('id') + '&defaultSet=true');

  let names = page.indexPage.skills.skillNames.toArray().map(name => name.text)

  assert.notOk(names.includes('JUnit'))
  assert.notOk(names.includes('Bash'))
  assert.ok(names.includes('Rails'))
});
