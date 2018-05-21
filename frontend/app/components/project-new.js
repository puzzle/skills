import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { computed } from '@ember/object';
import { isBlank } from '@ember/utils';

export default Component.extend({
  store: service(),
  i18n: service(),
  options: (['Advanced Routing', 'Angular'
    , 'BIND', 'C#', 'C', 'C++', 'CSS', 'CentOS', 'DHCP', 'Debian', 'DelayedJob Sidekiq', 'Docker'
    , 'EJB CDI', 'Fedora', 'GIT', 'HTML', 'Hybrid Mobile Apps', 'IPv6', 'JMS', 'JPA Hibernate'
    , 'JQuery', 'JUnit', 'Java SE', 'Java EE', 'Java', 'JavaScript/ECMAScript', 'Javascript', 'Jenkins', 'Linux'
    , 'Message Queues', 'Minitest', 'Mocha', 'Mockito', 'Network Appliances', 'NoSql', 'Openshift'
    , 'Passenger', 'Perl', 'Puma', 'Python', 'Qunit', 'R', 'REST', 'Red Hat', 'Relationale DBs', 'Resque'
    , 'Rspec', 'Ruby on Rails', 'Ruby', 'SASS', 'SQL', 'SUSE', 'Servlets', 'Shell Scripting', 'Sonar'
    , 'Stored Procedures', 'Travis', 'UML', 'Ubuntu', 'VLANs', 'WebSockets', 'WildFly / JBoss EAP']),

  newProject: computed('personId', function() {
    let project = this.get('store').createRecord('project');
    this.get('store').createRecord('project-technology', { project });
    return project;
  }),

  willDestroyElement() {
    if (this.get('newProject.isNew')) {
      this.get('newProject').destroyRecord();
    }
  },

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
    submit(newProject, event) {
      event.preventDefault();
      let person = this.get('store').peekRecord('person', this.get('personId'));
      newProject.set('person', person);
      return newProject.save()
        .then(() =>
          Promise.all([
            ...newProject
              .get('projectTechnologies')
              .map(projectTechnology => projectTechnology.save())
          ])
        )
        .then(project => this.sendAction('done'))
        .then(() => this.get('notify').success('Projekt wurde hinzugefügt!'))
        .catch(() => {
          this.get('newProject.errors').forEach(({ attribute, message }) => {
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
