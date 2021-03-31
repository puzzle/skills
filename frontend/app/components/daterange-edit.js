import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import ApplicationComponent from "./application-component";
import { isBlank } from "@ember/utils";
import { computed } from "@ember/object";

@classic
export default class DaterangeEdit extends ApplicationComponent {
  yearFromInvalid = false;
  yearToInvalid = false;

  init() {
    super.init(...arguments);
    this.monthsToSelect = ["heute", "-"].concat(
      Array(12)
        .fill()
        .map((x, i) => i + 1 + "")
    );
    this.monthsFromSelect = ["-"].concat(
      Array(12)
        .fill()
        .map((x, i) => i + 1 + "")
    );
  }

  @computed("entity.monthFrom")
  get selectedMonthFrom() {
    let selectedValue = this.entity.monthFrom;
    if (!this.entity.monthFrom) {
      selectedValue = "-";
    }
    return selectedValue;
  }

  @computed("entity.{monthTo,yearTo}")
  get selectedMonthTo() {
    let selectedValue = this.entity.monthTo;
    if (selectedValue) return selectedValue;
    if (this.entity.monthTo === null && this.entity.yearTo === null) {
      selectedValue = "heute";
    } else if (
      this.entity.monthTo === null ||
      this.entity.monthTo === undefined
    ) {
      selectedValue = "-";
    }
    return selectedValue;
  }

  validateYear(year, attr) {
    const invalid = attr + "Invalid";
    if (!this.get("entity").isYearValid(year)) {
      this.set(invalid, true);
      year = Math.abs(year)
        .toString()
        .slice(0, 4);
    } else {
      this.set(invalid, false);
    }
    return year;
  }

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  }

  setYear(year, attr) {
    let validatedYear = this.validateYear(year, "year" + attr);
    this.set("entity.year" + attr, validatedYear);
  }

  @action
  setMonth(attr, month) {
    this.set("entity.month" + attr, isNaN(month) ? null : month);
    if (month === "heute") this.entity.yearTo = null;
  }

  @action
  setYearFrom(year) {
    this.setYear(year, "From");
  }

  @action
  setYearTo(year) {
    this.setYear(year, "To");
  }

  @action
  handleFocus(select, e) {
    if (this.focusComesFromOutside(e)) {
      select.actions.open();
    }
  }

  @action
  handleBlur() {}
}
