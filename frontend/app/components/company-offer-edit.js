import Component from '@ember/component';
import { A } from '@ember/array';
import { isBlank } from '@ember/utils';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  store: service(),
  i18n: service(),
  options: A(['Barcelona', 'London', 'New York', 'Porto']),
  selected: [],

  actions: {
    submit(newOffer) {
      return newOffer.save()
        .then(function() {
        })
        .then(() => this.sendAction('submit', newOffer))
    .then(() => this.get('notify').success('Angebot wurde erstellt'))
    },

    createOnEnter(select, e) {
      if (e.keyCode === 13 && select.isOpen &&
        !select.highlighted && !isBlank(select.searchText)) {

        let selected = this.get('selected');
        if (!selected.includes(select.searchText)) {
          this.get('options').pushObject(select.searchText);
          select.actions.choose(select.searchText);
        }
      }
    }
  }
});
