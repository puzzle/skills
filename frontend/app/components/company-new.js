import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  store: service(),
  i18n: service(),


  actions: {
    submit(newCompany, newLocation) {
      return newCompany.save()
        .then(() => this.sendAction('submit', newCompany))
        .then(() => this.get('notify').success('Firma wurde erstellt'))
        .then(function() {
          newLocation.save(); //TODO: catch error
        });
    },

    // TODO: use later?
    addLocations() {
      let company = this.get('model');
      let location = this.get('store').createRecord('location');
      location.set('company', company);
    }


  }
});
