import { inject as service } from '@ember/service';
import Controller from '@ember/controller';


export default Controller.extend({
  session: service('session'),
  router: service(),

  actions: {
    transitionToProfile() {
      let username = this.get('session.data.authenticated.full_name')
      let people = this.get('store').findAll('person')
      people.then(() => {
        let person = people.filterBy('name', username)[0]
        if (person == undefined) {
          this.get('router').transitionTo('people')
        } else {
          this.get('router').transitionTo('person', person.id)
        }
      })
    }
  }
})
