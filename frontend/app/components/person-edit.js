import Ember from 'ember';

export default Ember.Component.extend({
  personPictureUploadPath:Ember.computed('person.id', function(){
    return `/people/${this.get('person.id')}/picture`
  })  
});
