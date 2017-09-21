import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({

  i18n: service(),

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(activity => this.sendAction('done'))
        .then(() => this.get('notify').success('Aktivität wurde aktualisiert!'))
        .catch(() => {
          let activity = this.get('activity');
          let errors = activity.get('errors').slice(); // clone array as rollbackAttributes mutates

          activity.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`activity.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },
    deleteActivity(activity, event) {
      activity.destroyRecord()
        .then(activity => this.sendAction('done'))
        .then(() => this.get('notify').success('Aktivität wurde entfernt!'));
    },
    confirmDestroy(activity) {
      this.send('deleteActivity', activity);
    }
  }
});
