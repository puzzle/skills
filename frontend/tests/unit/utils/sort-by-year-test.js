import EmberObject, { set } from '@ember/object';
import sortByYear from 'frontend/utils/sort-by-year';
import { module, test } from 'qunit';

module('Unit | Utility | sort by year');

test('it returns an empty array if collection is not available', function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear('educations'),
  });

  const thing = Thing.create({
    educations: null,
  });

  const sorted = thing.get('sortedEducations');

  assert.ok(Array.isArray(sorted));
  assert.equal(sorted.length, 0);
});

test('it sorts by year_to and year_from', function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear('educations'),
  });

  const thing = Thing.create({
    educations: [
      { year_from: 1994, year_to: 2000 },
      { year_from: 1989, year_to: 1989 },
      { year_from: 1990, year_to: 1994 },
      { year_from: 1990, year_to: 1995 },
      { year_from: 1993, year_to: null },
      { year_from: 1995, year_to: 2000 },
      { year_from: 2000, year_to: null },
      { year_from: 1989, year_to: 1989 },
      { year_from: 1994, year_to: 1999 },
    ],
  });

  assert.deepEqual(thing.get('sortedEducations'), [
    { year_from: 2000, year_to: null },
    { year_from: 1993, year_to: null },
    { year_from: 1995, year_to: 2000 },
    { year_from: 1994, year_to: 2000 },
    { year_from: 1994, year_to: 1999 },
    { year_from: 1990, year_to: 1995 },
    { year_from: 1990, year_to: 1994 },
    { year_from: 1989, year_to: 1989 },
    { year_from: 1989, year_to: 1989 },
  ]);
});

test('it recomputes on changes', function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear('educations'),
  });

  const thing = Thing.create({
    educations: [
      { year_from: 1994, year_to: 2000 },
      { year_from: 1993, year_to: null },
      { year_from: 1994, year_to: 1999 },
    ],
  });

  assert.deepEqual(thing.get('sortedEducations'), [
    { year_from: 1993, year_to: null },
    { year_from: 1994, year_to: 2000 },
    { year_from: 1994, year_to: 1999 },
  ]);

  thing.set('educations', [
    { year_from: 1994, year_to: 2000 },
    { year_from: 1993, year_to: 2001 },
    { year_from: 1994, year_to: 1999 },
  ]);

  assert.deepEqual(thing.get('sortedEducations'), [
    { year_from: 1994, year_to: 2000 },
    { year_from: 1994, year_to: 1999 },
    { year_from: 1993, year_to: 2001 },
  ]);

  set(thing.get('educations')[0], 'year_from', 1991);

  assert.deepEqual(thing.get('sortedEducations'), [
    { year_from: 1994, year_to: 1999 },
    { year_from: 1993, year_to: 2001 },
    { year_from: 1991, year_to: 2000 },
  ]);

  set(thing.get('educations')[1], 'year_to', null);

  assert.deepEqual(thing.get('sortedEducations'), [
    { year_from: 1993, year_to: null },
    { year_from: 1994, year_to: 1999 },
    { year_from: 1991, year_to: 2000 },
  ]);
});
