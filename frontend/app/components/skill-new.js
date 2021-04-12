import ApplicationComponent from "./application-component";
import { inject } from "@ember/service";
import { computed } from "@ember/object";
import { isBlank } from "@ember/utils";
import Skill from "../models/skill";

export default ApplicationComponent.extend({
  store: inject(),
  intl: inject(),

  init() {
    this._super(...arguments);
    this.set("newSkill", this.get("store").createRecord("skill"));
    this.radarOptions = Object.values(Skill.RADAR_OPTIONS);
    this.portfolioOptions = Object.values(Skill.PORTFOLIO_OPTIONS);
    this.set(
      "childCategories",
      this.get("store").query("category", { scope: "children" })
    );
  },

  selectedCategory: computed("newSkill.category", function() {
    return this.get("newSkill.category");
  }),

  didInsertElement() {
    //We need global jquery here because Bootstrap renders the modal outside of the component
    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    $("#skill-new-modal").on("hide.bs.modal", () => {
      this.abort();
    });
    /* eslint-enable no-global-jquery, no-undef, jquery-ember-run  */
  },

  abort() {
    if (!this.get("newSkill.id")) {
      this.get("newSkill").deleteRecord();
    }
    this.set("newSkill", this.get("store").createRecord("skill"));
  },

  categorySearchMatcher(category, term) {
    return `${category.get("title").toLowerCase()} ${category
      .get("parent.title")
      .toLowerCase()}`.indexOf(term.toLowerCase());
  },

  closeSelect(e, select) {
    if (e.keyCode == 13 || e.keyCode == 9) select.actions.close();
  },

  focusComesFromOutside(e) {
    if (!this.get("session").hasResourceRole("ADMIN")) return;

    const isChrome =
      !!window.chrome && (!!window.chrome.webstore || !!window.chrome.runtime);
    if (isChrome) return true;

    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  },

  actions: {
    abortNew() {
      /*this try catch is necessary because bootstrap modal does not work in acceptance tests,
      meaning, this would throw an error no matter if the actual feature works and the test
      would fail.*/
      /* eslint-disable no-undef  */
      try {
        $("#skill-new-modal").modal("hide");
      } catch (error) {
        Ember.Logger.warn(error.stack);
      }
      /* eslint-enable no-undef  */
    },

    setupNewSkill(skillTitle) {
      this.set("newSkill.title", skillTitle);
    },

    customSuggestion(term) {
      return `${term} neu hinzufügen!`;
    },

    setWithKey(saveAction, select, e) {
      if ((e.keyCode == 9 || e.keyCode == 13) && select.isOpen) {
        this.closeSelect(e, select);
        this.send(saveAction, select.highlighted);
      }
    },

    setCategory(category) {
      this.set("newSkill.category", category);
    },

    setRadar(radar) {
      this.set("newSkill.radar", radar);
    },

    setPortfolio(portfolio) {
      this.set("newSkill.portfolio", portfolio);
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e) && !e.currentTarget.innerText) {
        select.actions.open();
      }
    },

    handleBlur() {},

    async submit(event) {
      if (!this.get("session").hasResourceRole("ADMIN")) return;
      return this.get("newSkill")
        .save()
        .then(skill => this.refreshList(skill))
        .then(() => this.get("notify").success("Skill wurde erstellt!"))
        .then(() => this.send("abortNew"))
        .catch(() => {
          this.get("newSkill.errors").forEach(({ attribute, message }) => {
            let translated_attribute = this.get("intl").t(`skill.${attribute}`);
            if (message == "Dieser Skill existiert bereits")
              translated_attribute = "";
            this.get("notify").alert(`${translated_attribute} ${message}`, {
              closeAfter: 10000
            });
          });
        });
    }
  }
});
