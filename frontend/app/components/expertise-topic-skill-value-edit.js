import classic from "ember-classic-decorator";
import { tagName } from "@ember-decorators/component";
import { computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import ExpertiseTopicSkillValueModel from "../models/expertise-topic-skill-value";

const DEFAULT_SKILL_LEVEL = "trainee";

@classic
@tagName("")
export default class ExpertiseTopicSkillValueEdit extends Component {
  skillLevelData = ExpertiseTopicSkillValueModel.SKILL_LEVELS;

  @service
  store;

  @computed("expertiseTopic")
  get formId() {
    return `expertise-topic-${this.get("expertiseTopic.id")}-form`;
  }

  _expertiseTopicSkillValue = null;

  @computed
  set expertiseTopicSkillValue(value) {
    if (
      this._expertiseTopicSkillValue &&
      this._expertiseTopicSkillValue.get("isNew") &&
      !this._expertiseTopicSkillValue.get("isSaving")
    ) {
      this._expertiseTopicSkillValue.destroyRecord();
    }
    this._expertiseTopicSkillValue =
      value ||
      this.get("store").createRecord("expertise-topic-skill-value", {
        skillLevel: DEFAULT_SKILL_LEVEL
      });

    return this._expertiseTopicSkillValue;
  }

  get expertiseTopicSkillValue() {
    return this._expertiseTopicSkillValue;
  }
}
