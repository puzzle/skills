import Component from '@ember/component';
import { inject as service } from '@ember/service';
import sortByYear from '../utils/sort-by-year';
import { computed } from '@ember/object';


export default Component.extend({
  /* exclude where id like null */
  filteredEducations: computed('@each.id', function() {
    return this.get('sortedEducations').filterBy('id');
  }),

  sortedEducations: sortByYear('educations'),

  init() {
    this._super(...arguments);
  },

  i18n: service(),

  actions: {
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


        .catch(() => {
          let educations = person.get('educations');
          educations.forEach(education => {
            let errors = education.get('errors').slice(); // clone array as rollbackAttributes mutates

            education.rollbackAttributes();
            //TODO: rollback does not rollback all records in the forEach, some kind of bug

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('i18n').t(`education.${attribute}`)['string']
              this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
            });
          });

        });
    },
    deleteEducation(education) {
      education.destroyRecord()
        .then(() => this.get('notify').success('Weiterbildung wurde entfernt!'));
    },
    confirmDestroy(education) {
      this.send('deleteEducation', education);
    },
    abortEdit() {
      let educations = this.get('person.educations').toArray();
      educations.forEach(education => {
        if (education.get('hasDirtyAttributes')) {
          education.rollbackAttributes();
        }
      });
      this.sendAction('educationsEditing');
    }
  }
});
