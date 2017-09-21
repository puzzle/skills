import Component from '@ember/component';
import { computed } from '@ember/object';
import Ember from 'ember';
import ExpertiseTopicSkillValueModel from '../models/expertise-topic-skill-value'

const {
  inject
} = Ember;
const DEFAULT_SKILL_LEVEL = 'trainee';

export default Component.extend({
  skillLevelData: ExpertiseTopicSkillValueModel.SKILL_LEVELS,
  store: inject.service(),
  tagName: '',

  formId: computed('expertiseTopic', function() {
    return `expertise-topic-${this.get('expertiseTopic.id')}-form`;
  }),

  _expertiseTopicSkillValue: null,

  expertiseTopicSkillValue: computed({
    set(_key, value) {
      if (this._expertiseTopicSkillValue &&
          this._expertiseTopicSkillValue.get('isNew') &&
          !this._expertiseTopicSkillValue.get('isSaving')) {
        this._expertiseTopicSkillValue.destroyRecord();
      }
      this._expertiseTopicSkillValue = value ||
        this.get('store').createRecord('expertise-topic-skill-value', { skillLevel: DEFAULT_SKILL_LEVEL });

      return this._expertiseTopicSkillValue;
    },
    get() {
      return this._expertiseTopicSkillValue;
    }
  })
});
