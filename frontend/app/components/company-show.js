import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  router: service(),

  actions: {
    deleteCompany(companyToDelete) {
      companyToDelete.destroyRecord();
      window.location.reload(true);
      this.get('router').transitionTo('companies');
    }
  }
});
