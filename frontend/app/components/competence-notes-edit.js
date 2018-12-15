import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { isBlank } from '@ember/utils';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';


export default Component.extend(EKMixin, {
  intl: service(),
  store: service(),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
  }),

  abortCompetences: on(keyUp('Escape'), function() {
    let person = this.get('person');
    if (person.get('hasDirtyAttributes')) {
      person.rollbackAttributes();
    }
    this.competenceNotesEditing();
  }),

  actions: {

    submit(person) {
      person.save()
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Successfully saved!'))
        .catch(() => {
          let competences = this.get('person.personCompetences');
          competences.forEach(competence => {
            let errors = competence.get('errors').slice();

            if (competence.get('id') != null) {
              competence.rollbackAttributes();
            }

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('intl').t(`offer.${attribute}`)
              this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
            });
          });
        });
    },

    abortEdit() {
      if (this.get('person.hasDirtyAttributes')) {
        this.get('person').rollbackAttributes();
      }
      this.sendAction('competenceNotesEditing');
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
