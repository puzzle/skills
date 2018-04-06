import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import CompanyModel from '../models/company';

export default Component.extend({
  store: service(),
  i18n: service(),
  router: service(),

  personPictureUploadPath: computed('company.id', function() {
    return `/company/${this.get('company.id')}/picture`;
  }),

  actions: {
    submit(changeset) {
      return changeset.save()
        .then(() => this.sendAction('submit'))
    .then(() => this.get('notify').success('Firmenübersicht wurde aktualisiert!'))
    .catch(() => {
        let company = this.get('company');
      let errors = person.get('company').slice(); // clone array as rollbackAttributes mutates

      person.rollbackAttributes();
      errors.forEach(({ attribute, message }) => {
        let translated_attribute = this.get('i18n').t(`company.${attribute}`)['string']
        changeset.pushErrors(attribute, message);
      this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
    });
    });
    },
    deleteCompany(companyToDelete) {
      companyToDelete.destroyRecord();
      this.get('router').transitionTo('companies');
      window.location.reload(true);
    }
  }

});
