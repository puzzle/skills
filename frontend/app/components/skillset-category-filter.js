import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { isBlank } from "@ember/utils";

export default Component.extend({
  router: service(),

  init() {
    this._super(...arguments);

    this.get("parentCategories").then(categories => {
      this.set(
        "categories",
        [{ id: "", title: "Alle" }].concat(categories.toArray())
      );
      this.set(
        "selectedCategory",
        this.get("categories").find(
          category =>
            category.id ==
            this.get("router.currentState.routerJsState.queryParams.category")
        )
      );
    });
  },

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  },

  actions: {
    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {},

    setCategoryFilter(category) {
      this.set("selectedCategory", category);
      this.get("router").transitionTo({
        queryParams: { category: category.id }
      });
    }
  }
});
