import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { computed } from "@ember/object";

export default Component.extend({
  store: service(),
  intl: service(),

  tagName: "tr",
  classNames: ["content-row"],
  classNameBindings: ["editing:content-row-edit"],
  editing: false,
  expertiseTopic: null,

  click() {
    this.set("editing", true);
  },

  expertiseTopicSkillValue: computed(
    "person.expertiseTopicSkillValues.[]",
    "expertiseTopic.id",
    function() {
      return this.get("person.expertiseTopicSkillValues").findBy(
        "expertiseTopic.id",
        this.get("expertiseTopic.id")
      );
    }
  ),

  actions: {
    submit(changeset, event) {
      event.preventDefault();

      changeset.set("expertiseTopic", this.expertiseTopic);
      changeset.set("person", this.person);

      return changeset
        .save()
        .then(record => {
          this.notify.success("Fachwissen wurde aktualisiert");
          this.set("editing", false);
          this.set("expertiseTopicSkillValue", record);

          return record;
        })
        .catch(err => {
          let expertiseTopicSkillValue = this.expertiseTopicSkillValue;
          let errors = expertiseTopicSkillValue.get("errors").slice();
          expertiseTopicSkillValue.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.intl.t(
              `expertise-topic-skill-value.${attribute}`
            );
            changeset.pushErrors(attribute, message);
            this.notify.alert(`${translated_attribute} ${message}`, {
              closeAfter: 10000
            });
          });
        });
    },

    cancelEdit(changeset, event) {
      changeset.rollback();
      this.set("editing", false);
    }
  }
});
