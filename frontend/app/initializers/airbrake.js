export function initialize(app) {
  app.inject('route', 'service',  'service:airbrake-error');
}

export default {
  initialize
};
