import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { isBlank } from '@ember/utils';

export default Component.extend({

  i18n: service(),

  suggestion(term) {
    return `"${term}" hinzufügen!`;
  },

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains('ember-power-select-search-input');
  },

  actions: {
    submit(changeset, event) {
      event.preventDefault();
      return changeset.save()
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
    deleteProject(project) {
      project.destroyRecord()
        .then(project => this.sendAction('done'))
        .then(() => this.get('notify').success('Projekt wurde entfernt!'));
    },
    confirmDestroy(project) {
      this.send('deleteProject', project);
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {
    },

    createTechnology(selected, searchText)
    {
      let options = this.get('options');
      if (!options.includes(searchText)) {
        this.get('options').pushObject(searchText);
      }
      if (selected.includes(searchText)) {
        this.get('notify').alert("Already added!", { closeAfter: 4000 });
      }
      else {
        selected.pushObject(searchText);
      }

    }
  }
});
