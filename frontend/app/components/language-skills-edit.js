import ApplicationComponent from "./application-component";
import { inject } from "@ember/service";
import sortByLanguage from "../utils/sort-by-language";

export default ApplicationComponent.extend({
  store: inject(),
  init() {
    this._super(...arguments);
    this.levels = [
      "Keine",
      "A1",
      "A2",
      "B1",
      "B2",
      "C1",
      "C2",
      "Muttersprache"
    ];
    this.obligatoryLanguages = ["DE", "EN", "FR"];
    if (this.get("person.isNew")) this.setStandardSkills();
    this.set("languages", this.getLanguagesList());
    this.selectedSkill = this.get("person.languageSkills.firstObject");
    this.set(
      "isObligatoryLanguage",
      this.obligatoryLanguages.includes(this.selectedSkill.get("language"))
    );
  },

  sortedLanguageSkills: sortByLanguage("person.languageSkills").volatile(),

  getLanguagesList() {
    let languages = this.get("store").findAll("language");
    languages.then(() => {
      this.set("languages", languages);
      this.set(
        "selectedLanguage",
        this.getSelectedLanguage(
          this.get("person.languageSkills.firstObject.language")
        )
      );

      let personLanguages = this.get("person.languageSkills");
      personLanguages.then(() => {
        let languageIsos = personLanguages.map(x =>
          x.get("language").toLowerCase()
        );
        this.get("languages").forEach(function(language) {
          language.set(
            "disabled",
            languageIsos.includes(language.get("iso1").toLowerCase())
          );
        }, this);
        return languages;
      });
    });
  },

  setStandardSkills() {
    let skills = this.get("person.languageSkills");
    this.obligatoryLanguages.forEach(language => {
      let skillDummy = {
        certificate: "",
        level: "Keine",
        language,
        person: this.get("person")
      };
      let skill = this.get("store").createRecord("languageSkill", skillDummy);
      skills.pushObject(skill);
    });
  },

  getSelectedLanguage(language) {
    let languages = this.get("languages");
    let selected = languages
      .map(x => {
        if (x.get("iso1").toLowerCase() == language.toLowerCase()) {
          return x;
        }
      })
      .filter(function(n) {
        return n !== undefined;
      });
    if (!selected.length) return { name: "-", iso1: "-" };
    return selected[0];
  },

  actions: {
    setLevel(level) {
      this.set("selectedSkill.level", level);
    },

    setLanguage(language) {
      if (!this.get("selectedSkill.isNew"))
        this.set("selectedLanguage.disabled", false);
      language.set("disabled", true);
      this.set("selectedLanguage", language);
      this.set("selectedSkill.language", language.get("iso1"));
    },

    setSkill(skill) {
      this.set(
        "selectedLanguage",
        this.getSelectedLanguage(skill.get("language"))
      );
      this.set("selectedSkill", skill);
      this.set(
        "isObligatoryLanguage",
        this.obligatoryLanguages.includes(this.selectedSkill.get("language"))
      );
    },

    createSkill() {
      this.set("selectedLanguage", { iso1: "-" });
      this.set("isObligatoryLanguage", false);
      if (
        !this.get("person.languageSkills")
          .map(x => x.get("language"))
          .includes("-")
      ) {
        let newSkill = this.get("store").createRecord("languageSkill");
        newSkill.set("language", "-");
        newSkill.set("person", this.get("person"));
        this.send("setSkill", newSkill);
        this.notifyPropertyChange("sortedLanguageSkills");
      }
    },

    deleteSkill(skill) {
      let language = this.getSelectedLanguage(skill.get("language"));
      if (language.iso1 != "-") language.set("disabled", false);
      let length = this.get("person.languageSkills.length");
      setTimeout(() => {
        if (length > this.get("person.languageSkills.length")) {
          this.send("setSkill", this.get("person.languageSkills.firstObject"));
          this.notifyPropertyChange("sortedLanguageSkills");
        }
      }, 500);
    },

    handleFocus(select, e) {},

    handleBlur() {}
  }
});
