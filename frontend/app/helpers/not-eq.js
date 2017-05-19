import Ember from 'ember';

export function notEq([ firstArg, ...restArgs ]) {
  return restArgs.every(a => a !== firstArg);
}

export default Ember.Helper.helper(notEq);
