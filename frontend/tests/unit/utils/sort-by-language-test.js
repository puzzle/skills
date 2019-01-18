import EmberObject, { set } from '@ember/object';
import sortByLanguage from 'frontend/utils/sort-by-language';
import { module, test } from 'qunit';

module('Unit | Utility | sort by language');

test('it returns an empty array if collection is not available', function(assert) {
  const Thing = EmberObject.extend({
    sortedLanguageSkills: sortByLanguage('languageSkills'),
  });

  const thing = Thing.create({
    languageSkills: null,
  });

  const sorted = thing.get('sortedLanguageSkills');

  assert.ok(Array.isArray(sorted));
  assert.equal(sorted.length, 0);
});

test('it sorts by language', function(assert) {
  const Thing = EmberObject.extend({
    sortedLanguageSkills: sortByLanguage('languageSkills'),
  });

  const thing = Thing.create({
    languageSkills: [
      { language: "SR" },
      { language: "DE" },
      { language: "AF" },
      { language: "FR" },
      { language: "BN" },
      { language: "EN" },
      { language: "ES" },
    ],
  });

  assert.deepEqual(thing.get('sortedLanguageSkills'), [
    { language: "DE" },
    { language: "EN" },
    { language: "FR" },
    { language: "AF" },
    { language: "BN" },
    { language: "ES" },
    { language: "SR" },
  ]);
});

test('it recomputes on changes', function(assert) {
  const Thing = EmberObject.extend({
    sortedLanguageSkills: sortByLanguage('languageSkills'),
  });

  const thing = Thing.create({
    languageSkills: [
      { language: "SR" },
      { language: "DE" },
      { language: "AF" },
      { language: "FR" },
      { language: "NL" },
      { language: "BN" },
      { language: "EN" },
      { language: "ES" },
    ],
  });

  assert.deepEqual(thing.get('sortedLanguageSkills'), [
    { language: "DE" },
    { language: "EN" },
    { language: "FR" },
    { language: "AF" },
    { language: "BN" },
    { language: "ES" },
    { language: "NL" },
    { language: "SR" },
  ]);

  thing.set('languageSkills', [
    { language: "RU" },
    { language: "EN" },
    { language: "DE" },
    { language: "SV" },
    { language: "FR" },
  ]);

  assert.deepEqual(thing.get('sortedLanguageSkills'), [
    { language: "DE" },
    { language: "EN" },
    { language: "FR" },
    { language: "RU" },
    { language: "SV" },
  ]);

  set(thing.get('languageSkills')[0], 'language', "VI");

  assert.deepEqual(thing.get('sortedLanguageSkills'), [
    { language: "DE" },
    { language: "EN" },
    { language: "FR" },
    { language: "SV" },
    { language: "VI" },
  ]);
});
