import { create, visitable, fillable, collection } from "ember-cli-page-object";

export default create({
  indexPage: {
    visit: visitable("/cv_search"),
    visitPeople: visitable("/people"),
    searchInput: fillable("#cv-searchbar input"),
    people: {
      peopleNames: collection(".cv-search-pills"),
      peopleFoundInLink: collection(".cv-search-found-in-link")
    }
  }
});
