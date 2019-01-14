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

test('it sorts by finish_at and start_at', function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear('educations'),
  });

  const thing = Thing.create({
    educations: [
      { start_at: new Date(1994, 2, 1), finish_at: new Date(2000, 1, 1) },
      { start_at: new Date(1989, 4, 1), finish_at: new Date(1989, 8, 1) },
      { start_at: new Date(1990, 5, 1), finish_at: new Date(1994, 3, 1) },
      { start_at: new Date(1990, 9, 1), finish_at: new Date(1995, 2, 1) },
      { start_at: new Date(1989, 11, 1), finish_at: new Date(1989, 5, 1) },
      { start_at: new Date(1994, 7, 1), finish_at: new Date(1999, 8, 1) },
      { start_at: new Date(1995, 10, 1), finish_at: new Date(2000, 4, 1) },
      { start_at: new Date(1993, 2, 1), finish_at: null },
      { start_at: new Date(2000, 4, 1), finish_at: null },
    ],
  });

  assert.deepEqual(thing.get('sortedEducations'), [
    { start_at: new Date(2000, 4, 1), finish_at: null },
    { start_at: new Date(1993, 2, 1), finish_at: null },
    { start_at: new Date(1995, 10, 1), finish_at: new Date(2000, 4, 1) },
    { start_at: new Date(1994, 2, 1), finish_at: new Date(2000, 1, 1) },
    { start_at: new Date(1994, 7, 1), finish_at: new Date(1999, 8, 1) },
    { start_at: new Date(1990, 9, 1), finish_at: new Date(1995, 2, 1) },
    { start_at: new Date(1990, 5, 1), finish_at: new Date(1994, 3, 1) },
    { start_at: new Date(1989, 4, 1), finish_at: new Date(1989, 8, 1) },
    { start_at: new Date(1989, 11, 1), finish_at: new Date(1989, 5, 1) },
  ]);
});

test('it sorts by finish_at and start_at and considers 13th', function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear('educations'),
  });

  const thing = Thing.create({
    educations: [
      { start_at: new Date(1990, 5, 13), finish_at: new Date(1994, 3, 13) },
      { start_at: new Date(1993, 2, 1), finish_at: null },
      { start_at: new Date(1989, 4, 1), finish_at: new Date(1989, 8, 1) },
      { start_at: new Date(1990, 9, 1), finish_at: new Date(1995, 2, 1) },
      { start_at: new Date(1990, 5, 1), finish_at: new Date(1994, 3, 1) },
      { start_at: new Date(2000, 4, 1), finish_at: null },
      { start_at: new Date(1990, 9, 1), finish_at: new Date(1995, 2, 13) },
      { start_at: new Date(1993, 2, 13), finish_at: null },
      { start_at: new Date(1989, 4, 13), finish_at: new Date(1989, 8, 1) },
    ],
  });

  assert.deepEqual(thing.get('sortedEducations'), [
    { start_at: new Date(2000, 4, 1), finish_at: null },
    { start_at: new Date(1993, 2, 1), finish_at: null },
    { start_at: new Date(1993, 2, 13), finish_at: null },
    { start_at: new Date(1990, 9, 1), finish_at: new Date(1995, 2, 1) },
    { start_at: new Date(1990, 9, 1), finish_at: new Date(1995, 2, 13) },
    { start_at: new Date(1990, 5, 1), finish_at: new Date(1994, 3, 1) },
    { start_at: new Date(1990, 5, 13), finish_at: new Date(1994, 3, 13) },
    { start_at: new Date(1989, 4, 1), finish_at: new Date(1989, 8, 1) },
    { start_at: new Date(1989, 4, 13), finish_at: new Date(1989, 8, 1) },
  ]);
});

test('it recomputes on changes', function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear('educations'),
  });

  const thing = Thing.create({
    educations: [
      { start_at: new Date(1994, 4, 1), finish_at: new Date(2000, 0, 1) },
      { start_at: new Date(1993, 2, 1), finish_at: null },
      { start_at: new Date(1994, 6, 1), finish_at: new Date(1999, 3, 1) },
    ],
  });

  assert.deepEqual(thing.get('sortedEducations'), [
    { start_at: new Date(1993, 2, 1), finish_at: null },
    { start_at: new Date(1994, 4, 1), finish_at: new Date(2000, 0, 1) },
    { start_at: new Date(1994, 6, 1), finish_at: new Date(1999, 3, 1) },
  ]);

  thing.set('educations', [
    { start_at: new Date(1994, 3, 1), finish_at: new Date(2000, 6, 1) },
    { start_at: new Date(1993, 6, 1), finish_at: new Date(2001, 9, 1) },
    { start_at: new Date(1994, 8, 1), finish_at: new Date(1999, 11, 1) },
  ]);

  assert.deepEqual(thing.get('sortedEducations'), [
    { start_at: new Date(1993, 6, 1), finish_at: new Date(2001, 9, 1) },
    { start_at: new Date(1994, 3, 1), finish_at: new Date(2000, 6, 1) },
    { start_at: new Date(1994, 8, 1), finish_at: new Date(1999, 11, 1) },
  ]);

  set(thing.get('educations')[0], 'finish_at', new Date(1991, 4, 1));

  assert.deepEqual(thing.get('sortedEducations'), [
    { start_at: new Date(1993, 6, 1), finish_at: new Date(2001, 9, 1) },
    { start_at: new Date(1994, 8, 1), finish_at: new Date(1999, 11, 1) },
    { start_at: new Date(1994, 3, 1), finish_at: new Date(1991, 4, 1) },
  ]);

  set(thing.get('educations')[1], 'finish_at', null);

  assert.deepEqual(thing.get('sortedEducations'), [
    { start_at: new Date(1993, 6, 1), finish_at: null },
    { start_at: new Date(1994, 8, 1), finish_at: new Date(1999, 11, 1) },
    { start_at: new Date(1994, 3, 1), finish_at: new Date(1991, 4, 1) },
  ]);
});
