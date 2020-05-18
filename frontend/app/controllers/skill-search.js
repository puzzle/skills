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

  init() {
    super.init(...arguments);
    let filters;
    let skill_id = new URLSearchParams(window.location.search).get("skill_id");
    let level = new URLSearchParams(window.location.search).get("level");
    if (skill_id != null && skill_id != "") {
      filters = this.initFilters(skill_id.split(","), level.split(","));
    } else {
      filters = [{ selectedSkill: null, currentSkillId: null, levelValue: 1 }];
    }
    this.set("filters", filters);
  }

  initFilters(skill_id, level) {
    let filters = [];
    for (let i = 0; i < skill_id.length; i++) {
      filters.push({
        selectedSkill: this.store.peekRecord("skill", skill_id[i]),
        currentSkillId: skill_id[i],
        levelValue: level[i]
      });
    }
    return filters;
  }

  @computed
  get skills() {
    return this.store.findAll("skill", { reload: true });
  }

  updateSelection() {
    let skill_ids = "",
      levels = "";
    for (let i = 0; i < this.get("filters").length; i++) {
      if (this.get("filters." + i + ".currentSkillId") !== null) {
        skill_ids =
          skill_ids + "," + this.get("filters." + i + ".currentSkillId");
        levels = levels + "," + this.get("filters." + i + ".levelValue");
      }
    }
    if (skill_ids.length > 0) {
      skill_ids = skill_ids.substring(1);
      levels = levels.substring(1);
    }
    this.get("router").transitionTo({
      queryParams: {
        skill_id: skill_ids,
        level: levels
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
  }

  @action
  addFilter() {
    this.get("filters").pushObject({
      selectedSkill: null,
      currentSkillId: null,
      levelValue: 1
    });
    this.calculateOffset();
  }

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
