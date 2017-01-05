import Ember from 'ember';
import PersonModel from '../models/person';

const { Component, inject, computed } = Ember;

export default Ember.Component.extend({

  statusData:computed(function(){
    return Object.keys(PersonModel.STATUSES).map(id => {
      return { id, label: PersonModel.STATUSES[id] }
    });
  }),

  actions: {
    submit(newPerson) {
      return newPerson.save()
        .then(() => this.sendAction('submit'))
       this.get('router').transitionTo('people')
    }
  }
});
