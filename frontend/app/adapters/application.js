import { underscore } from '@ember/string';
import DS from 'ember-data';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';
import { pluralize } from 'ember-inflector'

export default DS.JSONAPIAdapter.extend(DataAdapterMixin, {
  namespace: 'api',
  authorizer: 'authorizer:auth',
  //coalesceFindRequests: true,

  pathForType(type) {
    return pluralize(underscore(type));
  }
});
