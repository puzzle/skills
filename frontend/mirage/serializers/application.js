import { JSONAPISerializer } from 'ember-cli-mirage';
import Ember from 'ember';

export default JSONAPISerializer.extend({
  keyForAttribute(attr) {
    return Ember.String.underscore(attr);
  }
});
