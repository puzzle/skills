import Ember from 'ember';

export function eq([ firstArg, ...restArgs ]) {
  return restArgs.every(a => a === firstArg);
}

export default Ember.Helper.helper(eq);
