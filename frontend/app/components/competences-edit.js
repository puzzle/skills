import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { isBlank } from '@ember/utils';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';


export default Component.extend(EKMixin, {
  i18n: service(),
  store: service(),


  init() {
    this._super(...arguments);
    this.options = (['Advanced Routing', 'Angular'
      , 'BIND', 'C#', 'C', 'C++', 'CSS', 'CentOS', 'DHCP', 'Debian', 'DelayedJob Sidekiq', 'Docker'
      , 'EJB CDI', 'Fedora', 'GIT', 'HTML', 'Hybrid Mobile Apps', 'IPv6', 'JMS', 'JPA Hibernate'
      , 'JQuery', 'JUnit', 'Java SE', 'Java EE', 'Java', 'JavaScript/ECMAScript', 'Javascript', 'Jenkins', 'Linux'
      , 'Message Queues', 'Minitest', 'Mocha', 'Mockito', 'Network Appliances', 'NoSql', 'Openshift'
      , 'Passenger', 'Perl', 'Puma', 'Python', 'Qunit', 'R', 'REST', 'Red Hat', 'Relationale DBs', 'Resque'
      , 'Rspec', 'Ruby on Rails', 'Ruby', 'SASS', 'SQL', 'SUSE', 'Servlets', 'Shell Scripting', 'Sonar'
      , 'Stored Procedures', 'Travis', 'UML', 'Ubuntu', 'VLANs', 'WebSockets', 'WildFly / JBoss EAP']);
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

  abortCompetences: on(keyUp('Escape'), function() {
    let person = this.get('person');
    if (person.get('hasDirtyAttributes')) {
      person.rollbackAttributes();
    }
    this.competencesEditing();
  }),

  actions: {

    submit(person) {
      person.save()
        .then (() =>
          Promise.all([
            ...person
              .get('personCompetences')
              .map(personCompetence => personCompetence.save())
          ])
        )
        .then (() => this.sendAction('submit'))
        .then (() => this.get('notify').success('Successfully saved!'))
        // TODO
        .catch(() => {
          let competences = this.get('person.personCompetences');
          competences.forEach(competence => {
            let errors = competence.get('errors').slice();

            if (competence.get('id') != null) {
              competence.rollbackAttributes();
            }

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get('i18n').t(`offer.${attribute}`)['string']
              this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
            });
          });
        });
    },

    abortEdit() {
      let competences = this.get('person.personCompetences').toArray();
      competences.forEach(competence => {
        if (competence.get('isNew')) {
          competence.destroyRecord();
        }
      });
      this.sendAction('competencesEditing');
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
