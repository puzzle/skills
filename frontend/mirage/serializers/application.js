import { JSONAPISerializer } from 'ember-cli-mirage';

export default JSONAPISerializer.extend({
  keyForAttribute: function(attr, method) {
    return Ember.String.underscore(attr);
  }
});
