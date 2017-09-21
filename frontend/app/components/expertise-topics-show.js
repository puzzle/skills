import Component from '@ember/component';
import { computed } from '@ember/object';
import RSVP from 'rsvp';
import Ember from 'ember';
import DS from 'ember-data';

const { Promise } = RSVP;
const {
  inject
} = Ember;

export default Component.extend({
  store: inject.service(),

  queryParams: computed('expertiseCategory.id', 'person.id', function() {
    return { category_id: this.get('expertiseCategory.id'), person_id: this.get('person.id') };
  }),

  expertiseTopics: computed('queryParams', function() {
    return this.get('store').query('expertise-topic', this.get('queryParams'));
  }),

  expertiseTopicSkillValues: computed('queryParams', function() {
    return this.get('store').query('expertise-topic-skill-value', this.get('queryParams'));
  }),

  isLoading: computed('expertiseTopics', 'expertiseTopicSkillValues', function() {
    return DS.PromiseObject.create({
      promise: Promise.all([
        this.get('expertiseTopics'),
        this.get('expertiseTopicSkillValues')
      ])
    });
  }),

  actions: {
    closeInfo() {
      this.set('showInfoModal', false);
    }
  }

});
