import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({
  store: service(),
  i18n: service(),

  newEducation: computed('personId', function() {
    return this.get('store').createRecord('education');
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
        .then(() => this.get('notify').success('Weiterbildung wurde hinzugefügt!'))
        .catch(() => {
          this.get('newEducation.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`education.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }
});
