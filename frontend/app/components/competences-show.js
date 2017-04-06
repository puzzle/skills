import Ember from 'ember';

export default Ember.Component.extend({
  competenceList:Ember.computed('person.competences', function(){
    let competences = this.get('person.competences')
    if(competences === null){ return ''; }
    return competences.split('\n')
  })
});
