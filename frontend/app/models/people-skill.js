import DS from 'ember-data';

export default DS.Model.extend({
  level: DS.attr('number'),
  interest: DS.attr('number'),
  certificate: DS.attr('boolean'),
  coreCompetence: DS.attr('boolean'),

  person: DS.belongsTo('person'),
  skill: DS.belongsTo('skill'),

  hasChangedAfterCreation() {
    return ['level', 'interest', 'certificate', 'coreCompetence'].map(attr =>  Boolean(this.get(attr))).includes(true)
  }
});
