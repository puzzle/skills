import Component from "@ember/component";
import { inject } from "@ember/service";
import { computed } from "@ember/object";
import { getOwner } from "@ember/application";

export default Component.extend({
  store: inject(),
  intl: inject(),

  init() {
    this._super(...arguments);
    this.set("newSkill", this.get("store").createRecord("skill"));
    this.set("newPeopleSkill", this.get("store").createRecord("peopleSkill"));
    ["level", "interest"].forEach(attr => {
      this.set("newPeopleSkill." + attr, 1);
    });
  },

  didInsertElement() {
    //We need global jquery here because Bootstrap renders the modal outside of the component
    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    $("#people-skill-new-modal").on("hide.bs.modal", () => {
      this.abort();
    });
    /* eslint-enable no-global-jquery, no-undef, jquery-ember-run  */
  },

  dropdownSkills: computed("person.peopleSkills.@each.id", function() {
    const peopleSkillsIds = this.get("person.peopleSkills").map(peopleSkill =>
      peopleSkill.get("skill.id")
    );
    let skills = this.get("store").findAll("skill", { reload: true });
    return skills.then(() => {
      skills = skills.filter(
        skill => !peopleSkillsIds.includes(skill.get("id"))
      );
      return skills.sort((a, b) => (a.get("title") < b.get("title") ? -1 : 1));
    });
  }),

  newSkillSelected: computed("newPeopleSkill.skill", function() {
    if (this.get("newPeopleSkill.skill.content") == null) return false;
    return this.get("newSkill.title") == this.get("newPeopleSkill.skill.title");
  }),

  selectedCategory: computed(
    "newPeopleSkill.skill",
    "newSkill.category",
    function() {
      if (this.get("newPeopleSkill.skill.content") == null) return null;
      return this.get(
        (this.get("newSkillSelected") ? "newSkill" : "newPeopleSkill.skill") +
          ".category"
      );
    }
  ),

  abort() {
    this.get("newSkill").deleteRecord();
    this.get("newPeopleSkill").deleteRecord();
    this.set("newSkill", this.get("store").createRecord("skill"));
    this.set("newPeopleSkill", this.get("store").createRecord("peopleSkill"));
    this.notifyPropertyChange("dropdownSkills");
    ["level", "interest"].forEach(attr => {
      this.set("newPeopleSkill." + attr, 1);
    });
  },

  categorySearchMatcher(category, term) {
    return `${category.get("title")} ${category.get("parent.title")}`.indexOf(
      term
    );
  },

  actions: {
    customSuggestion(term) {
      return `${term} neu hinzufügen!`;
    },

    setCategory(category) {
      this.set(
        (this.get("newSkillSelected") ? "newSkill" : "newPeopleSkill.skill") +
          ".category",
        category
      );
    },

    setupNewSkill(skillTitle) {
      this.set("newSkill.title", skillTitle);
      this.set("newPeopleSkill.skill", this.get("newSkill"));
    },

    abortNew() {
      /*this try catch is necessary because bootstrap modal does not work in acceptance tests,
      meaning, this would throw an error no matter if the actual feature works and the test
      would fail.*/
      /* eslint-disable no-undef  */
      try {
        $("#people-skill-new-modal").modal("hide");
      } catch (error) {
        Ember.Logger.warn(error.stack);
      }
      /* eslint-enable no-undef  */
    },

    async submit(event) {
      if (this.get("newSkillSelected")) {
        if (this.get("selectedCategory.content") != null)
          this.set("newSkill.category", this.get("selectedCategory"));
        let skill = this.get("newSkill")
          .save()
          .catch(() => {
            this.get("newSkill.errors").forEach(({ attribute, message }) => {
              let translated_attribute = this.get("intl").t(
                `skill.${attribute}`
              );
              this.get("notify").alert(`${translated_attribute} ${message}`, {
                closeAfter: 10000
              });
            });
          });
        await skill;
        if (this.get("newSkill.errors.length")) return;
        this.set("newPeopleSkill.skill", this.get("newSkill"));
      }

      this.set("newPeopleSkill.person", this.get("person"));
      return this.get("newPeopleSkill")
        .save()
        .then(() =>
          this.get("notify").success("Member-Skill wurde hinzugefügt!")
        )
        .then(() => this.send("abortNew"))
        .then(() => {
          // reload model hook with data for member skillset
          getOwner(this)
            .lookup("route:person.skills")
            .doRefresh();
        })
        .catch(() => {
          this.set("newPeopleSkill.person", null);
          this.get("newPeopleSkill.errors").forEach(
            ({ attribute, message }) => {
              let translated_attribute = this.get("intl").t(
                `peopleSkill.${attribute}`
              );
              this.get("notify").alert(`${translated_attribute} ${message}`, {
                closeAfter: 10000
              });
            }
          );
        });
    }
  }
});
