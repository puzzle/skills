import { helper } from "@ember/component/helper";
import { inject as service } from "@ember/service";

function selectedSkill([skillId]) {
  let x = skillId ? this.get("store").peekRecord("skill", skillId) : null;
  console.log(x);
  return x;
}

export default Ember.Helper.extend({
  store: Ember.inject.service("store"),

  compute(params, hash) {
    let store = this.get("store");
  }
});
