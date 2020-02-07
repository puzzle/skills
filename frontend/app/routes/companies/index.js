import classic from "ember-classic-decorator";
import Route from "@ember/routing/route";

@classic
export default class IndexRoute extends Route {
  queryParams = {
    q: {
      refreshModel: true,
      replace: true
    }
  };

  model({ q }) {
    return this.store.query("company", { q });
  }
}
