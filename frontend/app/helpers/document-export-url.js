import Ember from 'ember';
import ENV from '../config/environment';

export function documentExportUrl([personId]) {
  return `${ENV.APP.documentExportHost}/api/people/${personId}.odt`;
}

export default Ember.Helper.helper(documentExportUrl);
