import Ember from 'ember';
import { translationMacro as t } from "ember-i18n";

export default Ember.Component.extend({
  i18n: Ember.inject.service(),

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(advanced_training => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde aktualisiert!'))
        .catch(() => {
          let advanced_training = this.get('advanced-training');
          let errors = advanced_training.get('errors').slice(); // clone array as rollbackAttributes mutates

          advanced_training.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`advanced-training.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },
    deleteAdvancedTrainings(advancedTraining) {
      advancedTraining.destroyRecord()
        .then(advanced_training => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde entfernt!'))
    },
    confirmDestroy(advancedTraining){
      this.send('deleteAdvancedTrainings', advancedTraining);
    }
  }
});
