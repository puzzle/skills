import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import RSVP from "rsvp";
import DS from "ember-data";

const { Promise } = RSVP;

@classic
export default class ExpertiseTopicsShow extends Component {
  @service store;

  @computed("expertiseCategory.id", "person.id")
  get queryParams() {
    return {
      category_id: this.get("expertiseCategory.id"),
      person_id: this.get("person.id")
    };
  }

  @computed("queryParams")
  get expertiseTopics() {
    return this.store.query("expertise-topic", this.queryParams);
  }

  @computed("queryParams")
  get expertiseTopicSkillValues() {
    return this.store.query("expertise-topic-skill-value", this.queryParams);
  }

  @computed("expertiseTopics", "expertiseTopicSkillValues")
  get isLoading() {
    return DS.PromiseObject.create({
      promise: Promise.all([
        this.expertiseTopics,
        this.expertiseTopicSkillValues
      ])
    });
  }

  @action
  closeInfo() {
    this.set("showInfoModal", false);
  }
}
