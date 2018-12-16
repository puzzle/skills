import Component from '@ember/component';
import sortByYear from '../utils/sort-by-year';
import { inject as service } from '@ember/service';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';

export default Component.extend(EKMixin, {


  intl: service(),

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
    this.sortedActivities = sortByYear('activities').volatile()
  }),

  abortActivities: on(keyUp('Escape'), function() {
    this.send('abortEdit')
  }),

  actions: {
    notify() {
      let length = this.get('sortedActivities').length
      setTimeout(() => {
        if (length > this.get('sortedActivities').length) {
          return this.notifyPropertyChange('sortedActivities');
        }
      }, 500);
    },
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
        .then (() => this.$('#activity')[0].scrollIntoView({ behavior: 'smooth' }))

        .catch(() => {
          let activities = this.get('activities');
          activities.forEach(activity => {
            let errors = activity.get('errors').slice(); // clone array as rollbackAttributes mutates

            activity.rollbackAttributes();

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('intl').t(`activity.${attribute}`);
              this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
            });
          });

        });
    },
    abortEdit() {
      let activities = this.get('person.activities').toArray();
      activities.forEach(activity => {
        if (activity.get('hasDirtyAttributes')) {
          activity.rollbackAttributes();
        }
      });
      this.sendAction('activitiesEditing');
      this.$('#activity')[0].scrollIntoView({ behavior: 'smooth' });
    }
  }
});
