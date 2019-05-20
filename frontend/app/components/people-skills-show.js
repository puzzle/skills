import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  store: service(),
  i18n: service(),

  init() {
    this._super(...arguments);
    this.set('peopleSkillsEditing', false);
  },

  skills: computed(function() {
    return this.get('store').findAll('skill', { reload: true });
  }),

  parentCategories: computed(function() {
    return this.get('store').query('category', { scope: 'parents' });
  }),

  childCategories: computed(function() {
    return this.get('store').query('category', { scope: 'children' });
  }),

  amountOfPeopleSkills: computed('person.peopleSkills', function() {
    return this.get('person.peopleSkills.length')
  }),

  actions: {
    submit(person) {
      person.save()
        .then (() =>
          Promise.all([
            ...person
              .get('peopleSkills')
              .map(peopleSkill => peopleSkill.get('hasDirtyAttributes') ? peopleSkill.save() : null)
          ])
        )
        .then (() => this.set('peopleSkillsEditing', false))
        .then (() => this.get('notify').success('Successfully saved!'))
        .then (() => this.$('#peopleSkillsHeader')[0].scrollIntoView({ behavior: 'smooth' }))

        .catch(() => {
          let peopleSkills = person.get('peopleSkills');
          peopleSkills.forEach(peopleSkill => {
            let errors = peopleSkill.get('errors').slice(); // clone array as rollbackAttributes mutates

            peopleSkill.rollbackAttributes();
            //TODO: rollback does not rollback all records in the forEach, some kind of bug

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('i18n').t(`peopleSkill.${attribute}`)['string']
              this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
            });
          });

        });
    },

    abortEdit() {
      let peopleSkills = this.get('person.peopleSkills').toArray();
      peopleSkills.forEach(peopleSkill => {
        if (peopleSkill.get('hasDirtyAttributes')) {
          peopleSkill.rollbackAttributes();
        }
      });
      this.set('peopleSkillsEditing', false);
      this.$('#peopleSkillsHeader')[0].scrollIntoView({ behavior: 'smooth' });
    }
  }
});
