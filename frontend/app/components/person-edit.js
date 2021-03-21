import { inject as service } from "@ember/service";
import ApplicationComponent from "./application-component";
import { computed, observer } from "@ember/object";
import { isBlank } from "@ember/utils";
import { getNames as countryNames } from "ember-i18n-iso-countries";
import { on } from "@ember/object/evented";
import { EKMixin, keyUp } from "ember-keyboard";
import Person from "../models/person";
import PersonEditValidations from "../validations/person-edit";

export default ApplicationComponent.extend(EKMixin, {
  PersonEditValidations,
  store: service(),
  intl: service(),
  session: service("keycloak-session"),

  init() {
    this._super(...arguments);
    this.initMaritalStatuses();
    this.initNationalities();
    this.initCheckbox();
    this.get("person.company").then(company =>
      this.set("callBackCompany", company)
    );
    this.get("person.department").then(department =>
      this.set("callBackDepartment", department)
    );
    this.callBackRoleIds = {};
    this.get("person.personRoles").forEach(
      personRole =>
        (this.callBackRoleIds[personRole.get("id")] = personRole.get("role.id"))
    );
    this.store
      .findAll("personRoleLevel")
      .then(levels => this.set("personRoleLevelsToSelect", levels));
    this.allRoles = this.store.findAll("role");
  },

  personChanged: observer("person", function() {
    this.send("abortEdit");
    this.set("alreadyAborted", true);
  }),

  picturePath: computed("person.picturePath", function() {
    if (this.get("person.picturePath")) {
      let path =
        this.get("person.picturePath") +
        "&authorizationToken=" +
        this.get("session.token");
      return path;
    }
    return "";
  }),

  willDestroyElement() {
    this._super(...arguments);
    if (!this.alreadyAborted) this.send("abortEdit");
  },

  activateKeyboard: on("init", function() {
    this.set("keyboardActivated", true);
  }),

  aFunction: on(keyUp("Escape"), function() {
    this.send("abortEdit");
  }),

  initCheckbox() {
    if (this.get("person.nationality2")) {
      this.set("secondNationality", true);
    } else {
      this.set("secondNationality", false);
    }
  },

  initMaritalStatuses() {
    this.maritalStatusesHash = Person.MARITAL_STATUSES;
    this.set("maritalStatuses", Object.values(this.maritalStatusesHash));
    const maritalStatusKey = this.get("person.maritalStatus");
    this.set(
      "selectedMaritalStatus",
      this.maritalStatusesHash[maritalStatusKey]
    );
  },

  initNationalities() {
    const countriesArray = Object.entries(countryNames("de"));
    this.set("countries", countriesArray);
    const nationality = this.get("person.nationality");
    const nationality2 = this.get("person.nationality2");
    this.set("selectedNationality", this.getCountry(nationality));
    this.set("selectedNationality2", this.getCountry(nationality2));
  },

  getCountry(code) {
    return this.countries.find(function(country) {
      return country[0] === code;
    });
  },

  sortedRoles: computed("allRoles", function() {
    const usedRoleNames = this.get("person.personRoles").map(x =>
      x.get("role.name")
    );

    this.allRoles.forEach(role => {
      if (usedRoleNames.includes(role.get("name"))) {
        role.set("disabled", true);
      } else {
        role.set("disabled", undefined);
      }
    });
    return this.allRoles;
  }),

  companiesToSelect: computed(function() {
    return this.store.findAll("company");
  }),

  departmentsToSelect: computed(function() {
    return this.store.findAll("department");
  }),

  personRoleLevelsToSelect: computed(function() {
    return null;
  }),

  personPictureUploadPath: computed("person.id", function() {
    return `/people/${this.get("person.id")}/picture`;
  }),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  },

  actions: {
    submit(changeset) {
      return changeset
        .save()
        .then(() =>
          Promise.all([
            ...changeset
              .get("languageSkills")
              .map(languageSkill =>
                languageSkill.get("hasDirtyAttributes")
                  ? languageSkill.save()
                  : null
              ),
            ...changeset
              .get("personRoles")
              .map(personRole =>
                personRole.get("hasDirtyAttributes") ||
                personRole.get("role.id") !=
                  this.callBackRoleIds[personRole.get("id")]
                  ? personRole.save()
                  : null
              )
          ])
        )
        .then(() => this.set("alreadyAborted", true))
        .then(() => {
          this.sendAction("submit");
        })
        .then(() => this.notify.success("Personalien wurden aktualisiert!"))
        .catch(() => {
          let person = this.person;
          let errors = person.get("errors").slice(); // clone array as rollbackAttributes mutates

          person.get("languageSkills").forEach(skill => {
            errors = errors.concat(skill.get("errors").slice());
          });

          person.get("personRoles").forEach(personRole => {
            let prErrors = personRole.get("errors").slice();
            const roleIdError = prErrors.findBy("attribute", "role_id");
            prErrors.removeObject(roleIdError);
            errors = errors.concat(prErrors);
          });

          if (person.get("personRoles.length") === 0) {
            errors = errors.concat([
              { attribute: "person", message: "muss eine Funktion haben" }
            ]);
          }

          person.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.intl.t(`person.${attribute}`);
            changeset.pushErrors(attribute, message);
            this.notify.alert(`${translated_attribute} ${message}`, {
              closeAfter: 8000
            });
          });
        });
    },

    abortEdit() {
      const person = this.person;
      if (person.get("hasDirtyAttributes")) {
        person.rollbackAttributes();
      }

      this.set("person.company", this.callBackCompany);
      this.set("person.department", this.callBackDepartment);

      let languageSkills = this.get("person.languageSkills").toArray();
      languageSkills.forEach(skill => {
        if (skill.get("isNew")) {
          skill.destroyRecord();
        }
        if (skill.get("hasDirtyAttributes")) {
          skill.rollbackAttributes();
        }
      });

      this.get("person.personRoles").forEach(personRole => {
        if (personRole.get("isNew")) {
          personRole.destroyRecord();
        }
        if (personRole.get("hasDirtyAttributes")) {
          personRole.rollbackAttributes();
        }
      });

      this.get("person.personRoles").forEach(personRole => {
        let oldRoleId = this.get("callBackRoleIds." + personRole.get("id"));
        let role = this.store.peekRecord("role", oldRoleId);
        personRole.set("role", role);
      });

      this.set("alreadyAborted", true);
      this.sendAction("personEditing");
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {},

    switchNationality(value) {
      if (value == false) {
        this.set("person.nationality2", undefined);
      }
    },

    setBirthdate(selectedDate) {
      this.set("person.birthdate", selectedDate);
    },

    setNationality(selectedCountry) {
      this.set("person.nationality", selectedCountry[0]);
      this.set("selectedNationality", selectedCountry);
    },

    setNationality2(selectedCountry) {
      if (selectedCountry) {
        this.set("person.nationality2", selectedCountry[0]);
      } else {
        // nationality2 can be blank / cleared
        this.set("person.nationality2", undefined);
      }
      this.set("selectedNationality2", selectedCountry);
    },

    setDepartment(department) {
      this.set("person.department", department);
    },

    setCompany(company) {
      this.set("person.company", company);
    },

    setRole(personRole, selectedRole) {
      personRole.set("role", selectedRole);
    },

    setPersonRoleWithTab(personRole, select, e) {
      if (e.keyCode == 9 && select.isOpen) {
        personRole.set("role", select.highlighted);
      }
    },

    setPersonRoleLevel(personRole, personRoleLevel) {
      personRole.set("level", personRoleLevel.get("level"));
      personRole.set("personRoleLevel", personRoleLevel);
    },

    setPersonRoleLevelWithTab(personRole, select, e) {
      if (e.keyCode == 9 && select.isOpen) {
        personRole.set("level", select.highlighted.get("level"));
        personRole.set("personRoleLevel", select.highlighted);
      }
    },

    setRolePercent(personRole, event) {
      personRole.set("percent", event.target.value);
    },

    setMaritalStatus(selectedMaritalStatus) {
      const obj = this.maritalStatusesHash;
      const key = Object.keys(obj).find(
        key => obj[key] === selectedMaritalStatus
      );
      this.set("person.maritalStatus", key);
      this.set("selectedMaritalStatus", selectedMaritalStatus);
    },

    addRole(person) {
      this.store.createRecord("person-role", { person });
    }
  }
});
