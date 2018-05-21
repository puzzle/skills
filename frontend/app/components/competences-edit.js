import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  i18n: service(),
  store: service(),


  init() {
    this._super(...arguments);
  },

  actions: {
    submit(changeset) {

      changeset.save()
        .then(competence => this.sendAction('submit'))
        .then(() => this.get('notify').success('Kompetenzen wurden aktualisiert!'))
        .catch(() => {
          let competence = this.get('competence');
          let errors = competence.get('errors').slice(); // clone array as rollbackAttributes mutates

          competence.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`competence.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },

    submitPerson(person) {
      person.save()
        .then (() =>
          Promise.all([
            ...person
              .get('person_competences')
              .map(person_competence => person_competence.save())
              .get('competence')
              .map(competence => competence.save())
          ])
        )
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Successfully saved!'))
    },

    createNewOffer(person) {
      let bla = this.get('person');
      let competence = this.get('store').createRecord('person_competence', { bla });
      competence.set('offer', []);
      competence.set('category', "Test");
      console.log("Created: " + competence);
    },
  }
});
