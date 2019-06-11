import Component from "@ember/component";
import { inject as service } from "@ember/service";
import { computed, observer } from "@ember/object";

export default Component.extend({
  store: service(),
  intl: service(),

  init() {
    this._super(...arguments);
    this.set("peopleSkillsEditing", false);
    const categories = this.get("store").findAll("category");
    categories.then(() => {
      this.set("categories", categories);
      this.set(
        "childCategories",
        categories.filter(c => c.get("parent.content") != null)
      );
      this.setMemberSkillset();
    });
  },

  sidebarItems: computed("parentCategories", function() {
    let hash = {};

    if (!this.get("parentCategories")) return;
    this.get("parentCategories").forEach(category => {
      hash[category.get("title")] = "#parentCategory-" + category.id;
    });
    return hash;
  }),

  peopleSkillsChanged: observer("person.peopleSkills", function() {
    this.get("person.peopleSkills").then(() => {
      this.setMemberSkillset();
    });
  }),

  skills: computed(function() {
    return this.get("store").findAll("skill", { reload: true });
  }),

  amountOfPeopleSkills: computed("person.peopleSkills", function() {
    return this.get("person.peopleSkills.length");
  }),

  memberSkillset: computed("skillset", function() {
    return this.get("skillset");
  }),

  setMemberSkillset() {
    this.set(
      "parentCategories",
      this.get("categories").filter(c => c.get("parent.content") == null)
    );
    let memberSkillset = this.refreshMemberSkillset();
    this.set("skillset", memberSkillset);
  },

  refreshMemberSkillset() {
    let hash = [];
    // We require this hash because we want to order these entries and because the length
    // of the categories would not be possible to get by iterating over the models directly
    let peopleSkills = this.get("person.peopleSkills");
    this.get("parentCategories").forEach(parentCategory => {
      let childCategoriesWithSkills = parentCategory
        .get("children")
        .map(childCategory => {
          let title = childCategory.get("title");
          let skillIds = childCategory
            .get("skills")
            .map(skill => skill.get("id"));
          let childCategorySkills = peopleSkills
            .map(peopleSkill => {
              let skillId = peopleSkill.get("skill.id");
              if (skillIds.includes(skillId)) return peopleSkill;
            })
            .filter(Boolean);
          return {
            title,
            skills: childCategorySkills
          };
        });
      if (childCategoriesWithSkills) {
        hash.addObject({
          id: parentCategory.get("id"),
          title: parentCategory.get("title"),
          children: childCategoriesWithSkills
        });
      }
    });
    return hash;
  },

  actions: {
    submit(person) {
      person
        .save()
        .then(() =>
          Promise.all([
            ...person
              .get("peopleSkills")
              .map(peopleSkill =>
                peopleSkill.get("hasDirtyAttributes")
                  ? peopleSkill.save()
                  : null
              )
          ])
        )
        .then(() => this.set("peopleSkillsEditing", false))
        .then(() => this.get("notify").success("Successfully saved!"))
        .then(() =>
          this.$("#peopleSkillsHeader")[0].scrollIntoView({
            behavior: "smooth"
          })
        )

        .catch(() => {
          let peopleSkills = person.get("peopleSkills");
          peopleSkills.forEach(peopleSkill => {
            let errors = peopleSkill.get("errors").slice(); // clone array as rollbackAttributes mutates

            peopleSkill.rollbackAttributes();
            //TODO: rollback does not rollback all records in the forEach, some kind of bug

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get("intl").t(
                `peopleSkill.${attribute}`
              );
              this.get("notify").alert(`${translated_attribute} ${message}`, {
                closeAfter: 10000
              });
            });
          });
        });
    },

    abortEdit() {
      let peopleSkills = this.get("person.peopleSkills").toArray();
      peopleSkills.forEach(peopleSkill => {
        if (peopleSkill.get("hasDirtyAttributes")) {
          peopleSkill.rollbackAttributes();
        }
      });
      this.set("peopleSkillsEditing", false);
      this.$("#peopleSkillsHeader")[0].scrollIntoView({ behavior: "smooth" });
    }
  }
});
