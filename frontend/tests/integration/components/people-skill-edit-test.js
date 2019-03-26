import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import hbs from 'htmlbars-inline-precompile';

module('Integration | Component | people-skill-edit', function(hooks) {
  setupRenderingTest(hooks);

  test('it renders people-skill-edit without data', async function(assert) {
    await render(hbs`{{people-skill-edit}}`);

    let text = this.$().text();
    let checkboxes = this.$('[type="checkbox"]');

    assert.ok(text.includes('Niveau'));
    assert.ok(text.includes('Interesse'));
    assert.ok(text.includes('Zertifikat'));
    assert.ok(text.includes('Kernkompetenz'));
    assert.notOk(checkboxes[0].checked);
    assert.notOk(checkboxes[1].checked);
  });

  test('it renders people-skill-edit with data', async function(assert) {
    this.set('peopleSkill', {
      skill: {
        title: 'Rails'
      },
      level: 2,
      interest: 3,
      certificate: false,
      core_competence: true
    })

    await render(hbs`{{people-skill-edit peopleSkill=peopleSkill}}`);

    let text = this.$().text();
    let checkboxes = this.$('[type="checkbox"]');

    assert.ok(text.includes('Rails'));
    assert.ok(text.includes('2'));
    assert.ok(text.includes('3'));
    assert.notOk(checkboxes[0].checked);
    assert.ok(checkboxes[1].checked);
  });
});
