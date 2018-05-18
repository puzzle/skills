import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { inject as service } from '@ember/service';

export default Component.extend({
  /* exclude where id like null */
  filteredActivities: function() {
    return this.get('sortedActivities').filterBy('id');
  }.property('@each.id'),

  sortedActivities: sortByYear('activities'),

  i18n: service(),

  actions: {
    submit(person) {
      person.save()
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Successfully saved!'))
        .then (() =>
          Promise.all([
            ...person
              .get('activities')
              .map(activity => activity.save())
          ])
        )

        .catch(() => {
          let activity = this.get('activity');
          let errors = activity.get('errors').slice(); // clone array as rollbackAttributes mutates

          activity.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`offer.${attribute}`)['string']
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
