import Component from '@ember/component';
import { inject } from '@ember/service';

export default Component.extend({
  store: inject(),
  init() {
    this._super(...arguments);
    this.levels = ['Keine', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2', 'Muttersprache'];
    this.obligatoryLanguages = ['DE', 'EN', 'FR'];
    if (this.get('person.isNew')) this.setStandardSkills();
    this.set('languages', this.getLanguagesList());
    this.selectedSkill = this.get('person.languageSkills.firstObject');
    this.set('isObligatoryLanguage', this.obligatoryLanguages.includes(this.selectedSkill.get('language')));
  },

  getLanguagesList() {
    let languages = this.get('store').findAll('language');
    languages.then(() => {
      this.set('languages', languages);
      this.set('selectedLanguage', this.getSelectedLanguage(this.get('person.languageSkills.firstObject.language')));

      let personLanguages = this.get('person.languageSkills');
      personLanguages.then(() => {
        let languageIsos = personLanguages.map(x => x.get('language').toLowerCase());
        this.get('languages').forEach(function(language) {
          if (languageIsos.includes(language.get('iso1').toLowerCase())) {
            language.set('disabled', true);
          }
        }, this)
        return languages
      })
    })
  },

  setStandardSkills() {
    let skills = this.get('person.languageSkills');
    this.obligatoryLanguages.forEach(language => {
      let skillDummy = { certificate: '', level: 'Keine', language, person: this.get('person') };
      let skill = this.get('store').createRecord('languageSkill', skillDummy);
      skills.pushObject(skill);
    })
  },

  getSelectedLanguage(language) {
    let languages = this.get('languages')
    let selected = languages.map(x => {
      if (x.get('iso1').toLowerCase() == language.toLowerCase()) {
        return x;
      }
    }).filter(function(n) {return n !== undefined});
    if (!selected.length) return { name: "-", iso1: "-" }
    return selected[0]
  },

  actions: {
    setLanguageWithTab(select, e)
    {
      if (e.keyCode == 9) {
        this.send('setLanguage', select.highlighted)
      }
    },

    setLevelWithTab(select, e)
    {
      if (e.keyCode == 9) {
        this.set('selectedSkill.level', select.highlighted)
      }
    },

    setLanguage(language) {
      if (!this.get('selectedSkill.isNew')) this.set('selectedLanguage.disabled', false);
      language.set('disabled', true);
      this.set('selectedLanguage', language);
      this.set('selectedSkill.language', language.get('iso1'));
    },

    setSkill(skill) {
      this.set('selectedLanguage', this.getSelectedLanguage(skill.get('language')));
      this.set('selectedSkill', skill);
      this.set('isObligatoryLanguage', this.obligatoryLanguages.includes(this.selectedSkill.get('language')));
    },

    newSkill() {
      this.set('selectedLanguage', { iso1: '-' });
      this.set('isObligatoryLanguage', false);
      if (this.get('person.languageSkills').map(x => x.get('language')).includes('-')) return;
      let skillDummy = { certificate: '', level: '', language: '-', person: this.get('person') };
      let newSkill = this.get('store').createRecord('languageSkill', skillDummy);
      this.set('selectedSkill', newSkill);
      let skills = this.get('person.languageSkills');
      skills.then(() => {
        skills.pushObject(newSkill);
      })
    },

    deleteSkill(skill) {
      skill.destroyRecord()
        .then(skill => this.sendAction('done'))
        .then(() => this.get('notify').success('Sprache wurde entfernt!'))
      let language = this.getSelectedLanguage(skill.get('language'))
      language.set('disabled', false)
      this.send('setSkill', this.get('person.languageSkills.firstObject'));
    },

    handleFocus(select, e) {
    },

    handleBlur() {
    }
  }
});
