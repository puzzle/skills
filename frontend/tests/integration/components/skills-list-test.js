import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';
import Service from '@ember/service';

const storeStub = Service.extend({
  query(type, options) {
    return Promise.all(['Software Engineering', 'Beratung', 'System Engineer', 'Delivery'])
  },
});

module('Integration | Component | skills-list', function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function(assert) {
    this.owner.register('service:store', storeStub);
  });
  test('it renders without data', async function(assert) {

    await render(hbs`{{skills-list}}`);

    let text = this.$().text();

    assert.ok(text.includes('CSV Export'));
    assert.ok(text.includes('Neuer Puzzle-Skill'));
    assert.ok(text.includes('Skill'));
    assert.ok(text.includes('Radar'));
    assert.ok(text.includes('Members'));
  });

  test('it renders with data', async function(assert) {
    this.set('skills', [ {
      title: 'Ruby',
      portfolio: 'aktiv',
      radar: 'assess',
      category: {
        title: 'Software-Engineering'
      },
      people: ['person1', 'person2']
    },
    {
      title: 'Jenkins',
      portfolio: 'passiv',
      radar: 'assess',
      category: {
        title: 'CI/CD'
      },
      people: ['person1']
    }])

    await render(hbs`{{skills-list skills=skills}}`);

    let text = this.$().text();

    assert.ok(text.includes('Ruby'));
    assert.ok(text.includes('aktiv'));
    assert.ok(text.includes('assess'));
    assert.ok(text.includes('Software-Engineering'));
    assert.ok(text.includes('2'));
    assert.ok(text.includes('Jenkins'));
    assert.ok(text.includes('passiv'));
    assert.ok(text.includes('assess'));
    assert.ok(text.includes('CI/CD'));
    assert.ok(text.includes('1'));
  });
});
