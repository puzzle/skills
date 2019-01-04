import { moduleForComponent, test, skip } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('project-show', 'Integration | Component | project show', {
  integration: true
});

test('it renders project', function(assert) {
  this.set('project', {
    title: 'Dreaming Project',
    lineBreakDescription: 'Schlafen',
    lineBreakRole: 'Träumer',
    finish_at: new Date(1990, 1, 1),
    start_at: new Date(1991, 1, 1),
    lineBreakTechnology: 'Java'
  });

  this.render(hbs`{{project-show
    project=project
    selectProject=(action (mut projectEditing))
  }}`);

  assert.ok(this.$().text().includes('Dreaming Project'));
  assert.ok(this.$().text().includes('Schlafen'));
  assert.ok(this.$().text().includes('Träumer'));
  assert.ok(this.$().text().includes('1990'));
  assert.ok(this.$().text().includes('1991'));
  assert.ok(this.$().text().includes('Java'));
});

skip('project description, role and technology preserves whitespace', function(assert) {
  this.set('activity', {
    description: 'Preserves\nwhitespaces',
    role: 'Träumer',
    year_from: '1990',
    year_to: '1991'
  });

  this.set('project', {
    title: 'Dreaming Project',
    description: 'Schlafen',
    role: 'Träumer',
    technology: 'Ruby',
    year_from: '1990',
    year_to: '1991'
  });

  this.render(hbs`{{project-show
    project=project
    selectProject=(action (mut projectEditing))
  }}`);

  let $elements =
    this.$('[href="#collapseProjectDreaming Project"].project-title-text,' +
           '[id="collapseProjectDreaming Project"] div.col-sm-10');

  assert.equal($elements.length, 2);
});
