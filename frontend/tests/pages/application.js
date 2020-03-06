import {
  create,
  visitable,
  fillable,
  clickable,
  clickOnText
} from "ember-cli-page-object";

export default create({
  visitHome: visitable("/"),

  search: fillable("#field-search"),
  toggleAdvancedSearch: clickable("#toggleSearch"),
  profileMenuItem: clickable('a.nav-link[href="/people"]'),
  peopleMenuItem: clickOnText("#person-list a")
});
