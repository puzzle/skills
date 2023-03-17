import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { observes } from "@ember-decorators/object";
import { inject as service } from "@ember/service";
import Controller from "@ember/controller";
import $ from "jquery";

@classic
export default class SkillSearchController extends Controller {
  @service
  store;

  @service
  router;

  @action
  initFilters() {
    let filters = [];
    let skill_id = new URLSearchParams(window.location.search).get("skill_id");
    let level = new URLSearchParams(window.location.search).get("level");
    let interest = new URLSearchParams(window.location.search).get("interest");
    if (skill_id && level && interest) {
      let skill_ids = skill_id.split(",");
      let levels = level.split(",");
      let interests = interest.split(",");
      for (let i = 0; i < skill_ids.length; i++) {
        filters.pushObject({
          selectedSkill: this.store.findRecord("skill", parseInt(skill_ids[i])),
          currentSkillId: skill_ids[i],
          levelValue: levels[i],
          interestValue: interests[i]
        });
      }
    } else {
      filters = [
        {
          selectedSkill: null,
          currentSkillId: null,
          levelValue: 1,
          interestValue: 1
        }
      ];
    }
    this.set("filters", filters);
  }

  @computed
  get skills() {
    return this.store.findAll("skill", { reload: true });
  }

  updateSelection() {
    let skill_ids = "",
      levels = "",
      interests = "";
    for (let i = 0; i < this.get("filters").length; i++) {
      if (this.get("filters." + i + ".currentSkillId") !== null) {
        skill_ids =
          skill_ids + "," + this.get("filters." + i + ".currentSkillId");
        levels = levels + "," + this.get("filters." + i + ".levelValue");
        interests =
          interests + "," + this.get("filters." + i + ".interestValue");
      }
    }
    if (skill_ids.length > 0) {
      skill_ids = skill_ids.substring(1);
      levels = levels.substring(1);
      interests = interests.substring(1);
    }
    this.get("router").transitionTo({
      queryParams: {
        skill_id: skill_ids,
        level: levels,
        interest: interests
      }
    });
  }

  @computed("model")
  get sortSelection() {
    let sortedSkills = this.model.toArray().sort(function(a, b) {
      let x = a.person.get("name").localeCompare(b.person.get("name"));
      return x == 0
        ? a.skill.get("title").localeCompare(b.skill.get("title"))
        : x;
    });
    return sortedSkills;
  }

  @action
  setSkill(index, skill) {
    this.set("filters." + index + ".currentSkillId", parseInt(skill.get("id")));
    this.set("filters." + index + ".selectedSkill", skill);
  }

  @action
  removeFilter(index) {
    this.get("filters").removeAt(index);
    this.calculateOffset();
  }

  @observes(
    "filters.@each.currentSkillId",
    "filters.@each.levelValue",
    "filters.@each.interestValue",
    "filters.@each.skill"
  )
  valueChanged() {
    this.updateSelection();
  }

  @action
  resetFilter(index) {
    this.set("filters." + index + ".selectedSkill", null);
    this.set("filters." + index + ".currentSkillId", null);
    this.set("filters." + index + ".levelValue", 1);
    this.set("filters." + index + ".interestValue", 1);
  }

  @action
  addFilter() {
    this.get("filters").pushObject({
      selectedSkill: null,
      currentSkillId: null,
      levelValue: 1,
      interestValue: 1
    });
    this.calculateOffset();
  }

  @action
  calculateOffset() {
    switch (this.filters.length) {
      case 1:
        $("#skill-search-results-card").css("padding-top", "147px");
        break;
      case 2:
        $("#skill-search-results-card").css("padding-top", "229px");
        break;
      case 3:
        $("#skill-search-results-card").css("padding-top", "311px");
        break;
      case 4:
        $("#skill-search-results-card").css("padding-top", "393px");
        break;
      case 5:
        $("#skill-search-results-card").css("padding-top", "451px");
    }
  }
}
