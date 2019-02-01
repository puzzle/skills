import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';

export default Component.extend(EKMixin, {
  store: service(),
  i18n: service(),

  newEducation: computed('personId', function() {
    return this.get('store').createRecord('education');
  }),

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
  }),

  abortEducationNew: on(keyUp('Escape'), function() {
    if (this.get('newEducation.isNew')) {
      this.get('newEducation').destroyRecord();
    }
    this.done();
  }),

  willDestroyElement() {
    if (this.get('newEducation.isNew')) {
      this.get('newEducation').destroyRecord();
    }
  },

  actions: {
    submit(newEducation, event) {
      event.preventDefault();
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newEducation.set('person', person);
      return newEducation.save()
        .then(education => this.sendAction('done'))
        .then(() => this.get('notify').success('Ausbildung wurde hinzugefügt!'))
        .catch(() => {
          this.get('newEducation.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`education.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }
});
