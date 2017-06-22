import Ember from 'ember';

export default Ember.Component.extend({
  download: Ember.inject.service(),

  actions: {
    exportEmptyDevFws() {
      let url = `/api/documents/templates/fws.odt?empty=true&discipline=development`;
      this.get('download').file(url)
    },

    exportEmptySysFws() {
      let url = `/api/documents/templates/fws.odt?empty=true&discipline=system_engineering`;
      this.get('download').file(url)
    }
  }
});
