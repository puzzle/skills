import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  /* exclude where id like null */
  filteredActivities: computed('@each.id', function() {
    return this.get('sortedActivities').filterBy('id');
  }),

  sortedActivities: sortByYear('activities'),

  i18n: service(),

  actions: {
    submit(person) {
      person.save()
        .then (() =>
          Promise.all([
            ...person
              .get('activities')
              .map(activity => activity.save())
          ])
        )
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Successfully saved!'))


        .catch(() => {
          let activities = this.get('activities');
          activities.forEach(activity => {
            let errors = activity.get('errors').slice(); // clone array as rollbackAttributes mutates

            activity.rollbackAttributes();

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('i18n').t(`activity.${attribute}`)['string']
              this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
            });
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
    },
    abortEdit() {
      let activities = this.get('person.activities').toArray();
      activities.forEach(activity => {
        if (activity.get('hasDirtyAttributes')) {
          activity.rollbackAttributes();
        }
      });
      this.sendAction('activitiesEditing');
    }
  }
});
