import Ember from 'ember';

const { Component, inject } = Ember;

export default Component.extend({
  store: inject.service(),
  tagName: 'tr',
  classNames: 'content-row',
  initFunctions: Ember.on('init', function() {
    this._super();
    let expertiseTopicId= this.get('expertiseTopic').id
    let etsv = this.get('store').peekAll('expertise-topic-skill-value').find(function(record) {
      return record.get('expertiseTopic').get('id') === expertiseTopicId;
    })

    this.set('expertiseTopicSkillValue', etsv);
  })
});
