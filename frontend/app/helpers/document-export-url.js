import Ember from 'ember';
import ENV from '../config/environment';

export function documentExportUrl([personId]) {
  return `localhost:3000/api/people/${personId}.odt`;
}

export default Ember.Helper.helper(documentExportUrl);
