import Component from '@ember/component';
import { isBlank } from '@ember/utils';

export default Component.extend({
  init() {
    this._super(...arguments);
    this.set('interestLevelOptions', [1,2,3,4,5]);
  },

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },


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
