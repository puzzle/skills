import Component from '@ember/component';
import { isBlank } from '@ember/utils';
import { computed } from '@ember/object';

export default Component.extend({
  init() {
    this._super(...arguments);
    this.set('interestLevelOptions', [0,1,2,3,4,5]);
  },

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },

  levelName: computed('peopleSkill.level', function() {
    const levelNames = ['Nicht bewertet', 'Trainee', 'Junior', 'Professional', 'Senior', 'Expert'];
    return levelNames[this.get('peopleSkill.level')]
  }),


  actions: {
    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {
    },
  }
});
