import Ember from 'ember';
import ExpertiseTopicSkillValueModel from '../models/expertise-topic-skill-value'
import ExpertiseTopicSkillValueShow from './expertise-topic-skill-value-show';

const { computed, inject } = Ember;

export default ExpertiseTopicSkillValueShow.extend({
  store: inject.service(),
  classNames: 'content-row-edit',

  skillLevelData: computed(function() {
    return ExpertiseTopicSkillValueModel.SKILL_LEVELS;
  }),

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(() => this.get('notify').success('aktualisiert'))
    }
  }
});
