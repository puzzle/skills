import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { isBlank } from '@ember/utils';
import { isEmpty } from '@ember/utils';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';


export default Component.extend(EKMixin, {
  store: service(),
  i18n: service(),

  init() {
    this._super(...arguments);
    let project = this.get('project')
    if (isEmpty(project.get('projectTechnologies'))) {
      let technology = this.get('store').createRecord('project-technology', { project });
      technology.set('offer', []);
    }

  },

  suggestion(term) {
    return `"${term}" mit Enter hinzufügen!`;
  },

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

  abortProject: on(keyUp('Escape'), function() {
    let project = this.get('project')
    if (project.get('hasDirtyAttributes')) {
      project.rollbackAttributes();
    }
    this.done();
  }),

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
        .then(() =>
          Promise.all([
            ...changeset
              .get('projectTechnologies')
              .map(projectTechnology => projectTechnology.save())
          ])
        )
        .then(project => this.sendAction('done'))
        .then(() => this.get('notify').success('Projekt wurde aktualisiert!'))
        .catch(() => {
          let project = this.get('project');
          let errors = project.get('errors').slice(); // clone array as rollbackAttributes mutates

          project.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`project.${attribute}`)['string']
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
    },

  }
});
