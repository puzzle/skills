import ApplicationComponent from './application-component';
import { isBlank } from '@ember/utils';
import { computed, observer } from '@ember/object';

export default ApplicationComponent.extend({

  yearFromInvalid: false,
  yearToInvalid: false,

  init() {
    this._super(...arguments);
    this.monthsToSelect = ['heute', '-'].concat(Array(12).fill().map((x,i) => i + 1 + ""));
    this.monthsFromSelect = ['-'].concat(Array(12).fill().map((x,i) => i + 1 + ""));
    if (this.get('entity.isNew')) {
      ['To', 'From'].forEach(attr => this.send('setMonth' + attr, '-'))
    }
  },

  entityChanged: observer('entity', function() {
    ['To', 'From'].forEach(attr => this.send('setMonth' + attr, '-'))
  }),

  monthFrom: computed('entity.start_at', function() {
    if (this.get('entity.start_at') == null) return null;
    return this.getSelectedMonth(this.get('entity.start_at'));
  }),

  monthTo: computed('entity.finish_at', function() {
    return this.getSelectedMonth(this.get('entity.finish_at'));
  }),

  yearFrom: computed('entity.start_at', function() {
    return this.getSelectedYear(this.get('entity.start_at'));
  }),

  yearTo: computed('entity.finish_at', function() {
    return this.getSelectedYear(this.get('entity.finish_at'));
  }),

  getSelectedYear(date) {
    if (date == null) return null;
    return date.getFullYear();
  },

  getSelectedMonth(date) {
    if (date == null) return "heute";
    return [13, 14].includes(date.getDate()) ?  "-" : date.getMonth() + 1;
  },

  validateYear(year, attr) {
    const invalid = attr + 'Invalid';
    if (!this.get('entity').isYearValid(year)) {
      this.set(invalid, true);
      year = Math.abs(year).toString().slice(0,4);
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
      const year = this.get('entity.start_at') ? this.get('entity.start_at').getFullYear() : null;
      // sets day to 13 if no month is selected. Used as conditional in show hbs.
      if (isNaN(month)) {
        this.get('entity').setStartAt(year, 0, 14);
      }
      else {
        this.get('entity').setStartAt(year, month - 1, 2);
      }
    },

    setMonthTo(month) {
      const year = this.get('entity.finish_at') ? this.get('entity.finish_at').getFullYear() : null;
      // sets day to 13 if no month is selected. Used as conditional in show hbs.
      if (month == "-") {
        this.get('entity').setFinishAt(year, 11, 14);
      }
      else if (month == "heute") {
        this.set('entity.finish_at', null);
      }
      else {
        this.get('entity').setFinishAt(year, month - 1, 2);
      }
    },

    setYearFrom(year) {
      year = this.validateYear(year, 'yearFrom');
      let day = this.get('entity.start_at').getDate();
      let month = [13, 14].includes(day) ? 0 : this.get('entity.start_at').getMonth();
      this.get('entity').setStartAt(year, month, day);
    },

    setYearTo(year) {
      year = this.validateYear(year, 'yearTo');
      let day = this.get('entity.finish_at').getDate();
      let month = [13, 14].includes(day) ? 0 : this.get('entity.finish_at').getMonth();
      this.get('entity').setFinishAt(year, month, day);
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
