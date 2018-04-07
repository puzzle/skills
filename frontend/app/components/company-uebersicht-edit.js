import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  store: service(),
  i18n: service(),
  router: service(),

  actions: {
    submit(changeset) {
      return changeset.save()
        .then(() => this.sendAction('submit'))
        .then(() => this.get('notify').success('Firmenübersicht wurde aktualisiert!'))
        .catch(() => {
          let company = this.get('company');
          let errors = company.get('company').slice(); // clone array as rollbackAttributes mutates

          company.rollbackAttributes();
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
