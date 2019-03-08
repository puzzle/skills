import {
  create,
  visitable,
  clickable,
  fillable,
  collection,
} from 'ember-cli-page-object';

export default create({
  indexPage: {
    visit: visitable('/skills'),
    allFilterButton: clickable('#defaultFilterAll'),
    newFilterButton: clickable('#defaultFilterNew'),
    defaultFilterButton: clickable('#defaultFilterDefault'),
    skillsetSearchfield: fillable('#skillsetSearchfield'),
    skills: {
      skillNames: collection('#skills-list-table .skillname')
    }
  }
});
