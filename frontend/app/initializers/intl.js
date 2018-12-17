//export default {
//  // name: 'intl',
//
//  // after: 'ember-intl',
//
//  initialize(app) {
//    app.inject('model', 'intl', 'service:intl')
//  }
//};
export function initialize(app) {
  app.inject('model', 'intl', 'service:intl');
}

export default { initialize };
