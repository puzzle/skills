import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  store: service(),
  router: service(),

  init() {
    this._super(...arguments);
    const currentId = this.get('router.currentState.routerJsState.params.person.person_id');
    if (currentId) this.set('person', this.get('store').find('person', currentId))
  },
});
