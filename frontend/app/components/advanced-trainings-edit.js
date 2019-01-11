import { inject as service } from '@ember/service';
import Component from '@ember/component';
import sortByYear from "../utils/sort-by-year";
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';

export default Component.extend(EKMixin, {


  i18n: service(),

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
    this.sortedAdvancedTrainings = sortByYear('advanced-trainings').volatile()
  }),

  abortAdvancedTrainings: on(keyUp('Escape'), function() {
    let advancedTrainings = this.get('person.advancedTrainings').toArray();
    advancedTrainings.forEach(advancedTraining => {
      if (advancedTraining.get('hasDirtyAttributes')) {
        advancedTraining.rollbackAttributes();
      }
    });
    this.advancedTrainingsEditing();
  }),

  actions: {
    notify() {
      let length = this.get('sortedAdvancedTrainings').length
      setTimeout(() => {
        if (length > this.get('sortedAdvancedTrainings').length) {
          return this.notifyPropertyChange('sortedAdvancedTrainings');
        }
      }, 500);
    },
    submit(person) {
      person.save()
        .then (() =>
          Promise.all([
            ...person
              .get('advancedTrainings')
              .map(advancedTraining => advancedTraining.save())
          ])
        )
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Successfully saved!'))

        .catch(() => {
          let advancedTrainings = this.get('advanced-trainings');
          advancedTrainings.forEach(advancedTraining => {
            let errors = advancedTraining.get('errors').slice();

            advancedTraining.rollbackAttributes();

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('i18n').t(`advancedTraining.${attribute}`)['string']
              this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
            });
          });
        });
    },

    abortEdit() {
      let advancedTrainings = this.get('person.advancedTrainings').toArray();
      advancedTrainings.forEach(advancedTraining => {
        if (advancedTraining.get('hasDirtyAttributes')) {
          advancedTraining.rollbackAttributes();
        }
      });
      this.sendAction('advancedTrainingsEditing');
    }
  }
});
