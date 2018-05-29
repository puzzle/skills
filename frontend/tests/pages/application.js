import {
  create,
  visitable,
  fillable,
  clickable,
  clickOnText,
} from 'ember-cli-page-object';

export default create({
  visitHome: visitable('/'),

  search: fillable('#field-search'),
  toggleAdvancedSearch: clickable('#toggleSearch'),

  peopleMenuItem: clickOnText('#person-list a'),

  visitCompanies: visitable('/companies'),

  companiesMenuItem: clickOnText('#companies-list a')
})
