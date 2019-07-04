import Component from "@ember/component";
import { inject } from "@ember/service";
import { computed } from "@ember/object";
import { getOwner } from "@ember/application";
import ENV from "../config/environment";

export default Component.extend({
  store: inject(),
  ajax: inject(),
  intl: inject(),
  router: inject(),

  isLoading: true,
  minimumLoadTime: 1000,

  didReceiveAttrs() {
    this._super(...arguments);

    this.get("skills").then(skills => {
      this.refreshNewPeopleSkills(skills);
    });
  },

  refreshNewPeopleSkills(skills) {
    this.set("isLoading", true);
    let loadBegin = Date.now();
    this.get("ajax")
      .request("/skills/unrated_by_person", {
        data: {
          person_id: this.get("person.id")
        }
      })
      .then(response => {
        let loadEnd = Date.now();
        // have to disable the minimumLoadTime in tests
        if (
          loadEnd - loadBegin > this.get("minimumLoadTime") ||
          ENV.environment == "test"
        ) {
          this.set("isLoading", false);
        } else {
          setTimeout(() => {
            this.set("isLoading", false);
          }, this.get("minimumLoadTime") - (loadEnd - loadBegin));
        }
        let responseIds = response.data.map(skill => skill.id);
        let peopleSkills = skills
          .map(skill => {
            if (responseIds.includes(skill.get("id"))) {
              let ps = this.get("store").createRecord("peopleSkill");
              ps.set("skill", skill);
              return ps;
            }
          })
          .filter(x => x !== undefined);
        peopleSkills.sort((a, b) => {
          if (a.get("skill.title") > b.get("skill.title")) return 1;
          if (a.get("skill.title") < b.get("skill.title")) return -1;
          return 0;
        });
        this.set("newPeopleSkills", peopleSkills);
      });
  },

  newPeopleSkillsAmount: computed("newPeopleSkills", function() {
    return this.get("newPeopleSkills.length");
  }),

  isClosed: computed("newPeopleSkills", function() {
    return !this.get("newPeopleSkills.length");
  }),

  actions: {
    saveWithDefault(peopleSkill) {
      ["interest", "level", "certificate", "coreCompetence"].forEach(attr => {
        peopleSkill.set(attr, 0);
      });
      peopleSkill.set("person", this.get("person"));
      this.set(
        "newPeopleSkills",
        this.get("newPeopleSkills").removeObject(peopleSkill)
      );
      peopleSkill.save().then(() => {
        this.notifyPropertyChange("newPeopleSkills");
        // reload model hook with data for member skillset
        getOwner(this)
          .lookup("route:person.skills")
          .doRefresh();
      });
    },

    async submit(person) {
      let changedPeopleSkills = [];
      this.get("newPeopleSkills")
        .toArray()
        .forEach(ps => {
          if (ps.get("isRated")) {
            ps.set("person", this.get("person"));
            changedPeopleSkills.push(ps);
          }
        });

      changedPeopleSkills.forEach(peopleSkill => {
        Promise.all([peopleSkill.save()])
          .then(() => {
            this.set(
              "newPeopleSkills",
              this.get("newPeopleSkills").removeObject(peopleSkill)
            );
            this.notifyPropertyChange("newPeopleSkills");
          })
          .then(() => window.scroll({ top: 0, behavior: "smooth" }))
          .then(() => this.get("notify").success("Successfully saved!"))
          .then(() => {
            // reload model hook with data for member skillset
            getOwner(this)
              .lookup("route:person.skills")
              .doRefresh();
          })
          .catch(() => {
            let errors = peopleSkill.get("errors").slice();
            peopleSkill.set("person", null);
            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get("intl").t(
                `peopleSkill.${attribute}`
              );
              let msg =
                translated_attribute +
                " von " +
                peopleSkill.get("skill.title") +
                " " +
                message;
              this.get("notify").alert(msg, { closeAfter: 10000 });
            });
          });
        return peopleSkill.get("id");
      });
    },

    close() {
      this.set("isClosed", true);
    }
  }
});
