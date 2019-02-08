import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { isPresent } from '@ember/utils';

export default Component.extend({
  router: service(),
  i18n: service(),

  actions: {
    openConfirmation() {
      this.set('showConfirmation', true);
    },

    cancel() {
      this.set('showConfirmation', false);
    },

    delete(entry, transitionTo) {
      const message = this.get('i18n')
        .t('delete-confirmation.success',
          { name: entry.get('instanceToString') })['string']

      entry.destroyRecord().then(() => {
        this.set('showConfirmation', false);
        if (isPresent(transitionTo)) {
          this.get('router').transitionTo(transitionTo);
        }
        this.get('notify').success(message);
      });
    }
  }
});
