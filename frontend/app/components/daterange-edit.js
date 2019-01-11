import Component from '@ember/component';
import { isBlank } from '@ember/utils';

export default Component.extend({

  yearFromInvalid: false,
  yearToInvalid: false,

  init() {
    this._super(...arguments);
    this.months = ["-"].concat(Array(12).fill().map((x,i) => i + 1 + ""));
    this.initProperties();
  },

  initProperties() {
    if (!this.get('entity.isNew')) {
      let finish_at = this.get('entity.finish_at');
      let start_at = this.get('entity.start_at');
      this.monthFrom = this.getSelectedMonth(start_at);
      if (start_at != null) this.yearFrom = start_at.getFullYear();
      this.monthTo = this.getSelectedMonth(finish_at);
      if (finish_at != null) this.yearTo = finish_at.getFullYear();
    }
  },

  getSelectedMonth(date) {
    if (date == null) return;
    return date.getDate() == 13 ?  "-" : date.getMonth() + 1;
  },

  validateYear(year, attr) {
    const invalid = attr + 'Invalid'
    if (!this.get('entity').isYearValid(year)) {
      this.set(invalid, true);
      year = Math.abs(year).toString().slice(0,4)
    } else {
      this.set(invalid, false);
    }
    return year;
  },

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },

  actions: {
    setMonthFrom(month) {
      // sets day to 13 if no month is selected. Used as conditional in show hbs.
      if (isNaN(month)) {
        this.get('entity').setStartAt(this.yearFrom, 0, 14)
      }
      else {
        this.get('entity').setStartAt(this.yearFrom, month - 1, 1)
      }
      this.set('monthFrom', month);
    },

    setMonthTo(month) {
      // sets day to 13 if no month is selected. Used as conditional in show hbs.
      if (isNaN(month)) {
        this.get('entity').setFinishAt(this.yearTo, 11, 14)
      }
      else {
        this.get('entity').setFinishAt(this.yearTo, month - 1, 1)
      }
      this.set('monthTo', month);
    },

    setYearFrom(year) {
      year = this.validateYear(year, 'yearFrom')
      let day = this.get('entity.start_at').getDate()
      let month = [13, 14].includes(day) ? "-" : this.monthFrom
      this.set('yearFrom', year);
      this.send("setMonthFrom", month);
    },

    setYearTo(year) {
      year = this.validateYear(year, 'yearTo')
      let day = this.get('entity.finish_at').getDate()
      let month = [13, 14].includes(day) ? "-" : this.monthTo
      this.set('yearTo', year);
      this.send("setMonthTo", month);
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {
    },
  }
});
