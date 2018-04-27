import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import PersonModel from '../models/person';

export default Component.extend({
  store: service(),
  i18n: service(),

  companiesToSelect: computed(function(){
    return this.get('store').findAll('company');
  }),


  personPictureUploadPath: computed('person.id', function() {
    return `/people/${this.get('person.id')}/picture`;
  }),

  statusData: computed(function() {
    return Object.keys(PersonModel.STATUSES)
      .map(id => Number(id))
      .map(id => {
        return { id, label: PersonModel.STATUSES[id] };
      });
  }),

  actions: {
    submit(changeset) {
      return changeset.save()
        .then(() => this.sendAction('submit'))
        .then(() => this.get('notify').success('Personalien wurden aktualisiert!'))
        .catch(() => {
          let person = this.get('person');
          let errors = person.get('errors').slice(); // clone array as rollbackAttributes mutates

          person.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`person.${attribute}`)['string']
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    }
  }

});
