import Ember from 'ember';

export function or(params) {
  return params.find(Boolean);
}

export default Ember.Helper.helper(or);
