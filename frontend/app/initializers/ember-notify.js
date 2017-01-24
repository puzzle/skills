
export function initialize(application) {
  // Injects all Ember components with a router object:
  application.inject('component', 'notify', 'service:notify');
}

export default {
  name: 'notify',
  initialize: initialize
};
