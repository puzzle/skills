import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

export default Ember.Component.extend({

  i18n: Ember.inject.service(),

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then( activity => this.sendAction('done'))
        .then(() => this.get('notify').success('Aktivität wurde aktualisiert!'))
        .catch(() => {
          this.get('activity.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`activity.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },
    deleteActivity(activity, event) {
      activity.destroyRecord()
        .then( activity => this.sendAction('done'))
        .then(() => this.get('notify').success('Aktivität wurde entfernt!'));
    },
    confirmDestroy(activity){
      this.send('deleteActivity', activity);
    }
  }
});
