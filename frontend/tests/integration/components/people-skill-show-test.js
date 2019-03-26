import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | people-skill-show', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders people-skill-show with data', async function(assert) {
    this.set('peopleSkill', {
      skill: {
        title: 'Rails'
      },
      level: 2,
      interest: 3,
      certificate: false,
      core_competence: true
    })

    await render(hbs`{{people-skill-show peopleSkill=peopleSkill}}`);

    let text = this.$().text();

    assert.ok(text.includes('Rails'));
    assert.ok(text.includes('2'));
    assert.ok(text.includes('3'));
    assert.ok(text.includes('false'));
    assert.ok(text.includes('true'));
  });
});
