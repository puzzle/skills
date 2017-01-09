import { JSONAPISerializer } from 'ember-cli-mirage';
import Ember from 'ember';

export default JSONAPISerializer.extend({
  keyForAttribute: function(attr) {
    return Ember.String.underscore(attr);
  }
});
