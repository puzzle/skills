import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';


export default Component.extend(EKMixin, {
  store: service(),
  i18n: service(),

  newActivity: computed('personId', function() {
    return this.get('store').createRecord('activity');
  }),

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
  }),

  abortActivityNew: on(keyUp('Escape'), function() {
    if (this.get('newActivity.isNew')) {
      this.get('newActivity').destroyRecord();
    }
    this.done();
  }),

  willDestroyElement() {
    if (this.get('newActivity.isNew')) {
      this.get('newActivity').destroyRecord();
    }
  },

  actions: {
    submit(newActivity, event) {
      event.preventDefault();
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newActivity.set('person', person);
      return newActivity.save()
        .then(education => this.sendAction('done'))
        .then(() => this.get('notify').success('Aktivität wurde hinzugefügt!'))
        .catch(() => {
          this.get('newActivity.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`activity.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }
});
