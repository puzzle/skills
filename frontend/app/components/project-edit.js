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
    this.options = ['Advanced Routing', 'Angular'
      , 'BIND', 'C#', 'C', 'C++', 'CSS', 'CentOS', 'DHCP', 'Debian', 'DelayedJob Sidekiq', 'Docker'
      , 'EJB CDI', 'Fedora', 'GIT', 'HTML', 'Hybrid Mobile Apps', 'IPv6', 'JMS', 'JPA Hibernate'
      , 'JQuery', 'JUnit', 'Java SE', 'Java EE', 'Java', 'JavaScript/ECMAScript', 'Javascript', 'Jenkins', 'Linux'
      , 'Message Queues', 'Minitest', 'Mocha', 'Mockito', 'Network Appliances', 'NoSql', 'Openshift'
      , 'Passenger', 'Perl', 'Puma', 'Python', 'Qunit', 'R', 'REST', 'Red Hat', 'Relationale DBs', 'Resque'
      , 'Rspec', 'Ruby on Rails', 'Ruby', 'SASS', 'SQL', 'SUSE', 'Servlets', 'Shell Scripting', 'Sonar'
      , 'Stored Procedures', 'Travis', 'UML', 'Ubuntu', 'VLANs', 'WebSockets', 'WildFly / JBoss EAP'];

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
