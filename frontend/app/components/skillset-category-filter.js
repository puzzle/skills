import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { isBlank } from "@ember/utils";

@classic
export default class SkillsetCategoryFilter extends Component {
  @service router;

  init() {
    super.init(...arguments);

    this.parentCategories.then(categories => {
      this.set(
        "categories",
        [{ id: "", title: "Alle" }].concat(categories.toArray())
      );
      this.set(
        "selectedCategory",
        this.categories.find(
          category =>
            category.id ==
            this.get("router.currentState.routerJsState.queryParams.category")
        )
      );
    });
  }

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  }

  @action
  handleFocus(select, e) {
    if (this.focusComesFromOutside(e)) {
      select.actions.open();
    }
  }

  @action
  handleBlur() {}

  @action
  setCategoryFilter(category) {
    this.set("selectedCategory", category);
    this.router.transitionTo({
      queryParams: { category: category.id }
    });
  }
}
