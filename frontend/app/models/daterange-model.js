import DS from 'ember-data';

export default DS.Model.extend({
  finish_at: DS.attr('date'),
  start_at: DS.attr('date'),

  setStartAt(year, month, day) {
    this.set('start_at', this.toDate(year, month, day));
  },

  setFinishAt(year, month, day) {
    this.set('finish_at', this.toDate(year, month, day));
  },

  toDate(year, month, day) {
    let date = new Date(1970, month, day);
    if (!isNaN(year)) date.setFullYear(year, month, day);
    return date;
  },

  isYearValid(year) {
    if (year.length == 4 && year > 0) return true;
    return false;
  }
});
