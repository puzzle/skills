
export function initialize(application) {
  application.inject('component', 'notify', 'service:notify');
  application.inject('route', 'notify', 'service:notify');
}

export default {
  name: 'notify',
  initialize
};
