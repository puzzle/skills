import Helper from "@ember/component/helper";
import { inject as service } from "@ember/service";

export default Helper.extend({
  store: service(),

  compute(level) {
    return this.get("store")
      .findAll("personRoleLevel")
      .then(
        personRoleLevels =>
          personRoleLevels.filter(l => l.get("level") === level[0])[0]
      );
  }
});
