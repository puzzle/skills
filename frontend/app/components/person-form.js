import BaseFormComponent from "./base-form-component";
import { inject as service } from "@ember/service";
import { action, computed } from "@ember/object";
import { isBlank } from "@ember/utils";
import { getNames as countryNames } from "ember-i18n-iso-countries";
import Person from "../models/person";
import { addObserver } from "@ember/object/observers";

export default class PersonFormComponent extends BaseFormComponent {
  @service store;
  @service session;
  @service ajax;

  constructor() {
    super(...arguments);
    this.record = this.args.person || this.store.createRecord("person");
    addObserver(this, "args.person", this.personChanged);
  }

  @computed
  get departments() {
    return this.store.findAll("department");
  }

  @computed
  get personRoleLevels() {
    return this.store.findAll("personRoleLevel");
  }

  @computed
  get roles() {
    return this.store.findAll("role");
  }

  @computed
  get companies() {
    return this.store.findAll("company");
  }

  @computed()
  get countries() {
    let lang = navigator.language.split("-")[0];
    return Object.entries(countryNames(lang));
  }

  @computed()
  get maritalStatuses() {
    return Object.values(Person.MARITAL_STATUSES);
  }

  @computed
  get picturePath() {
    if (!this.record.picturePath) return "";
    return `${this.record.picturePath}&authorizationToken=${
      this.session.token
    }`;
  }

  @action
  submit(person) {
    let attributes = [
      person.languageSkills.toArray(),
      person.personRoles.toArray()
    ].flat();
    let picturePath = person.picturePath;
    super.submit(person).then(
      res =>
        res &&
        super
          .submit(attributes)
          .then(res =>
            res
              ? this.savePicture(picturePath)
              : person.set("picturePath", picturePath)
          )
          .then(res => res === true && this.afterSuccess(create))
    );
    let create = this.record.id;
  }

  savePicture(picturePath) {
    if (!picturePath) return true;
    if (picturePath.startsWith("/api/people")) return true;
    let uploadPath = `/people/${this.record.id}/picture`;

    return fetch(picturePath)
      .then(res => res.blob())
      .then(res => {
        let fd = new FormData();
        fd.append("picture", res);
        return fd;
      })
      .then(res =>
        this.ajax.put(uploadPath, {
          contentType: false,
          processData: false,
          timeout: 5000,
          data: res
        })
      )
      .then(() => this.notify.success(this.intl.t("image.upload-success")))
      .then(() => true)
      .catch(err => {
        this.notify.alert(err.message);
        return false;
      });
  }

  @action
  abort(event) {
    if (event) event.preventDefault();
    this.record.rollbackAttributes();
    this.args.abort();
  }

  afterSuccess(existing) {
    this.args.submit(this.record);
    if (existing) {
      this.notify.success(this.intl.t("person-form.update-success"));
    } else {
      this.notify.success(this.intl.t("person-form.create-success"));
    }
  }

  @action
  personChanged() {
    this.abort();
  }

  @action
  handleFocus(select, e) {
    if (this.focusComesFromOutside(e)) {
      select.actions.open();
    }
  }

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  }

  @action
  setWithTab(saveAction, select, e) {
    if (e.keyCode === 9 && select.isOpen) {
      saveAction(select.highlighted);
    }
  }

  @action
  addRole(person) {
    this.store.createRecord("person-role", { person });
  }

  @action
  setPersonRoleLevel(personRole, personRoleLevel) {
    personRole.level = personRoleLevel.level;
    personRole.level = personRoleLevel.level;
    personRole.personRoleLevel = personRoleLevel;
  }

  @action
  setNationality(country) {
    this.record.nationality = country[0];
  }

  @action
  switchNationality(value) {
    this.record.nationality2 = value.target.checked
      ? this.record.nationality
      : null;
  }

  @action
  setNationality2(country) {
    this.record.nationality2 = country[0];
  }
}
