import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({

  i18n: service(),


  actions: {
    submit(newCompany) {
      return newCompany.save()
        .then(() => this.sendAction('submit', newCompany))
        .then(() => this.get('notify').success('Firma wurde erstellt'));
    }
  }
});
