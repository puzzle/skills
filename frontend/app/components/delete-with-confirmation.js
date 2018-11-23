import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { isPresent } from '@ember/utils';

export default Component.extend({
  router: service(),

  actions: {

    openConfirmation() {
      this.set('showConfirmation', true);
    },

    cancel() {
      this.set('showConfirmation', false);
    },

    delete(entry, transitionTo) {
      entry.destroyRecord().then(() => {
        this.set('showConfirmation', false);
        if (isPresent(transitionTo)) {
          this.get('router').transitionTo(transitionTo);
        }
      });
    }
  }
});
