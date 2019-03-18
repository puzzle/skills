import {
  create,
  visitable,
  clickable,
  collection,
} from 'ember-cli-page-object';

export default create({
  indexPage: {
    visit: visitable('/skills'),
    allFilterButton: clickable('#defaultFilterAll'),
    newFilterButton: clickable('#defaultFilterNew'),
    defaultFilterButton: clickable('#defaultFilterDefault'),
    skills: {
      skillNames: collection('#skills-list-table .skillname')
    }
  }
});
