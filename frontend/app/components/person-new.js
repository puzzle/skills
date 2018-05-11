import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import PersonModel from '../models/person';
import { isBlank } from '@ember/utils';

export default Component.extend({
  i18n: service(),

  store: service(),

  companiesToSelect: computed(function() {
    return this.get('store').findAll('company');
  }),


  statusData: computed(function() {
    return Object.keys(PersonModel.STATUSES)
      .map(id => Number(id))
      .map(id => {
        return { id, label: PersonModel.STATUSES[id] };
      });
  }),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },

  actions: {
    submit(newPerson) {
      return newPerson.save()
        .then(() => this.sendAction('submit', newPerson))
        .then(() => this.get('notify').success('Person wurde erstellt!'))
        .catch(() => {
          this.get('newPerson.errors').forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`person.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {
    }
  }
});
