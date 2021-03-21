import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import { sort } from "@ember/object/computed";
import Component from "@ember/component";

@classic
export default class SkillsList extends Component {
  @service store;

  @service download;

  @sort("skills", (a, b) => {
    // this is needed because otherwise the skills would get reordered
    // while editing and saving a skill without a title
    if (a.get("title") === "" || b.get("title") === "") return 0;
    return a.get("title") - b.get("title");
  })
  sortedSkills;

  init() {
    super.init(...arguments);
    this.set("editSkills", []);
    this.set("categories", this.store.findAll("category", { reload: true }));
  }

  @computed("categories")
  get parentCategories() {
    return this.categories.then(categories =>
      categories.toArray().filter(c => !c.get("parent.content"))
    );
  }

  @computed("categories")
  get childCategories() {
    return this.categories.then(categories =>
      categories.toArray().filter(c => Boolean(c.get("parent.content")))
    );
  }

  @action
  exportSkillsetOdt(e) {
    e.preventDefault();
    let url = "/api/skills?format=odt";
    this.download.file(url);
  }

  @action
  startEditing(skill) {
    this.editSkills.addObject(skill);
  }

  @action
  stopEditing(skill) {
    this.editSkills.removeObject(skill);
  }

  @action
  toggleSkill(skill) {
    this.set("currentSkill", skill);
  }

  @action
  refreshList(skill) {
    this.set("skills", this.skills.toArray().addObject(skill));
  }
}
