export function initialize(app) {
  app.inject('model', 'intl', 'service:intl');
}

export default { initialize };
