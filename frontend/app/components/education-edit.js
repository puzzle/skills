import Ember from 'ember';

export default Ember.Component.extend({

  i18n: Ember.inject.service(),

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(education => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde aktualisiert!'))
        .catch(() => {
          let education = this.get('education');
          let errors = education.get('errors').slice(); // clone array as rollbackAttributes mutates

          education.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`education.${attribute}`)['string']
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        })

    },
    deleteEducation(education) {
      education.destroyRecord()
        .then( education => this.sendAction('done'))
        .then(() => this.get('notify').success('Weiterbildung wurde entfernt!'));
    },
    confirmDestroy(education){
      this.send('deleteEducation', education);
    }
  }
});
