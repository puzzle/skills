import Route from '@ember/routing/route';

export default Route.extend({


  actions: {
    reloadCompaniesList() {
      this.refresh();
    }
  }
});
