import Component from '@ember/component';
import { inject } from '@ember/service';
import { computed } from '@ember/object';

export default Component.extend({
  store: inject(),
  ajax: inject(),
  i18n: inject(),

  didReceiveAttrs() {
    this._super(...arguments);

    this.get('skills').then(skills => {
      this.refreshNewPeopleSkills(skills);
    })
  },

  refreshNewPeopleSkills(skills) {
    this.get('ajax').request('/skills/unrated_by_person', {
      data: {
        person_id: this.get('person.id'),
      }
    }).then(response => {
      let responseIds = response.data.map(skill => skill.id)
      let peopleSkills = skills.map(skill => {
        if (responseIds.includes(skill.get('id'))) {
          let ps = this.get('store').createRecord('peopleSkill')
          ps.set('skill', skill)
          return ps
        }
      }).filter(x => x !== undefined)
      this.set('newPeopleSkills', peopleSkills);
    })
  },

  newPeopleSkillsAmount: computed('newPeopleSkills', function() {
    return this.get('newPeopleSkills.length');
  }),

  isClosed: computed('newPeopleSkills', function() {
    return !this.get('newPeopleSkills.length');
  }),

  actions: {
    saveWithDefault(peopleSkill) {
      ['interest', 'level', 'certificate', 'coreCompetence'].forEach(attr => {
        peopleSkill.set(attr, 0);
      });
      peopleSkill.set('person', this.get('person'));
      this.set('newPeopleSkills', this.get('newPeopleSkills').removeObject(peopleSkill))
      peopleSkill.save();
      this.notifyPropertyChange('newPeopleSkills');
    },

    async submit(person) {
      let changedPeopleSkills = [];
      this.get('newPeopleSkills').toArray().forEach(ps => {
        if (ps.hasChangedAfterCreation()) {
          ps.set('person', this.get('person'));
          changedPeopleSkills.push(ps);
        }
      });

      changedPeopleSkills.forEach(peopleSkill => {
        Promise.all(
          [peopleSkill.save()]
        ).then (() => {
          this.set('newPeopleSkills', this.get('newPeopleSkills').removeObject(peopleSkill))
          this.notifyPropertyChange('newPeopleSkills')
        })
          .then (() => window.scroll({ top: 0, behavior: "smooth" }))
          .then (() => this.get('notify').success('Successfully saved!'))
          .catch(() => {
            let errors = peopleSkill.get('errors').slice()
            peopleSkill.set('person', null);
            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('i18n').t(`peopleSkill.${attribute}`)['string']
              let msg = translated_attribute + ' von ' + peopleSkill.get('skill.title') + ' ' + message
              this.get('notify').alert(msg, { closeAfter: 10000 });
            });
          });
        return peopleSkill.get('id')
      })
    },

    close() {
      this.set('isClosed', true);
    }
  }
});
