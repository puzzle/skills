import { inject as service } from '@ember/service';
import Component from '@ember/component';
import sortByYear from "../utils/sort-by-year";

export default Component.extend({
  /* exclude where id like null */
  filteredAdvancedTrainings: function() {
    return this.get('sortedAdvancedTrainings').filterBy('id');
  }.property('@each.id'),

  sortedAdvancedTrainings: sortByYear('advanced-trainings'),

  i18n: service(),

  actions: {
    submit(person) {
      person.save()
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Successfully saved!'))
        .then (() =>
          Promise.all([
            ...person
              .get('advanced-trainings')
              .map(advancedTraining => advancedTraining.save())
          ])
        )

        .catch(() => {
          let advancedTraining = this.get('advanced-training');
          let errors = advancedTraining.get('errors').slice(); // clone array as rollbackAttributes mutates

          advancedTraining.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`offer.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },
    deleteAdvancedTrainings(advancedTraining) {
      advancedTraining.destroyRecord()
        .then(advanced_training => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde entfernt!'))
    },
    confirmDestroy(advancedTraining) {
      this.send('deleteAdvancedTrainings', advancedTraining);
    }
  }
});
