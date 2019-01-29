import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';

export default Component.extend(EKMixin, {
  store: service(),
  i18n: service(),

  newAdvancedTraining: computed('personId', function() {
    return this.get('store').createRecord('advancedTraining');
  }),

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
  }),

  abortAdvancedTrainingNew: on(keyUp('Escape'), function() {
    if (this.get('newAdvancedTraining.isNew')) {
      this.get('newAdvancedTraining').destroyRecord();
    }
    this.done();
  }),

  willDestroyElement() {
    if (this.get('newAdvancedTraining.isNew')) {
      this.get('newAdvancedTraining').destroyRecord();
    }
  },

  setInitialState(context) {
    context.set('newAdvancedTraining', context.get('store').createRecord('advancedTraining'));
  },

  actions: {
    abortNew(event) {
      event.preventDefault();
      this.sendAction('done');
    },

    submit(newAdvancedTraining, initNew, event) {
      event.preventDefault();
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newAdvancedTraining.set('person', person);
      return newAdvancedTraining.save()
        .then(advancedTraining => {
          if (!initNew) this.sendAction('done');
          this.sendAction('setInitialState', this)
        })
        .then(() => this.get('notify').success('Weiterbildung wurde hinzugefügt!'))
        .catch(() => {
          this.get('newAdvancedTraining.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`advancedTraining.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }
});
