import Component from '@ember/component';
import { inject as service } from '@ember/service';
import sortByYear from '../utils/sort-by-year';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';

export default Component.extend(EKMixin, {
  intl: service(),

  init() {
    this._super(...arguments);
    this.sortedEducations = sortByYear('educations').volatile()
  },

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
  }),

  abortEducations: on(keyUp('Escape'), function() {
    this.send('abortEdit')
  }),

  actions: {
    notify() {
      let length = this.get('sortedEducations').length
      setTimeout(() => {
        if (length > this.get('sortedEducations').length) {
          return this.notifyPropertyChange('sortedEducations');
        }
      }, 500);
    },
    submit(person) {
      person.save()
        .then (() =>
          Promise.all([
            ...person
              .get('educations')
              .map(education => education.save())
          ])
        )
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Successfully saved!'))
        .then (() => this.$('#educationsHeader')[0].scrollIntoView({ behavior: 'smooth' }))

        .catch(() => {
          let educations = person.get('educations');
          educations.forEach(education => {
            let errors = education.get('errors').slice(); // clone array as rollbackAttributes mutates

            education.rollbackAttributes();
            //TODO: rollback does not rollback all records in the forEach, some kind of bug

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('intl').t(`education.${attribute}`)
              this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
            });
          });

        });
    },
    abortEdit() {
      let educations = this.get('person.educations').toArray();
      educations.forEach(education => {
        if (education.get('hasDirtyAttributes')) {
          education.rollbackAttributes();
        }
      });
      this.sendAction('educationsEditing');
      this.$('#educationsHeader')[0].scrollIntoView({ behavior: 'smooth' });
    }
  }
});
