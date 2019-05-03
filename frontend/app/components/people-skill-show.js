import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({
  levelName: computed('peopleSkill.level', function() {
    const levelNames = ['Nicht bewertet', 'Trainee', 'Junior', 'Professional', 'Senior', 'Expert'];
    return levelNames[this.get('peopleSkill.level')]
  }),
});
