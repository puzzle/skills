import EmberObject, { set } from "@ember/object";
import sortByYear from "frontend/utils/sort-by-year";
import { module, test } from "qunit";

module("Unit | Utility | sort by year");

test("it returns an empty array if collection is not available", function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear("educations")
  });

  const thing = Thing.create({
    educations: null
  });

  const sorted = thing.get("sortedEducations");

  assert.ok(Array.isArray(sorted));
  assert.equal(sorted.length, 0);
});

test("it sorts by finish_at and start_at", function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear("educations")
  });

  const thing = Thing.create({
    educations: [
      { yearFrom: 1994, monthFrom: 2, yearTo: 2000, monthTo: 1 },
      { yearFrom: 1989, monthFrom: 4, yearTo: 1989, monthTo: 8 },
      { yearFrom: 1990, monthFrom: 5, yearTo: 1994, monthTo: 3 },
      { yearFrom: 1990, monthFrom: 9, yearTo: 1995, monthTo: 2 },
      { yearFrom: 1989, monthFrom: 11, yearTo: 1989, monthTo: 5 },
      { yearFrom: 1994, monthFrom: 7, yearTo: 1999, monthTo: 8 },
      { yearFrom: 1995, monthFrom: 10, yearTo: 2000, monthTo: 4 },
      { yearFrom: 1993, monthFrom: 2, yearTo: null, monthTo: null },
      { yearFrom: 2000, monthFrom: 4, yearTo: null, monthTo: null }
    ]
  });

  assert.deepEqual(thing.get("sortedEducations"), [
    { yearFrom: 2000, monthFrom: 4, yearTo: null, monthTo: null },
    { yearFrom: 1993, monthFrom: 2, yearTo: null, monthTo: null },
    { yearFrom: 1995, monthFrom: 10, yearTo: 2000, monthTo: 4 },
    { yearFrom: 1994, monthFrom: 2, yearTo: 2000, monthTo: 1 },
    { yearFrom: 1994, monthFrom: 7, yearTo: 1999, monthTo: 8 },
    { yearFrom: 1990, monthFrom: 9, yearTo: 1995, monthTo: 2 },
    { yearFrom: 1990, monthFrom: 5, yearTo: 1994, monthTo: 3 },
    { yearFrom: 1989, monthFrom: 4, yearTo: 1989, monthTo: 8 },
    { yearFrom: 1989, monthFrom: 11, yearTo: 1989, monthTo: 5 }
  ]);
});

test("it sorts by finish_at and start_at and considers null months", function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear("educations")
  });

  const thing = Thing.create({
    educations: [
      { yearFrom: 1990, monthFrom: 5, yearTo: 1994, monthTo: null },
      { yearFrom: 1993, monthFrom: 2, yearTo: null, monthTo: null },
      { yearFrom: 1989, monthFrom: 4, yearTo: 1989, monthTo: 8 },
      { yearFrom: 1990, monthFrom: 9, yearTo: 1995, monthTo: 2 },
      { yearFrom: 1990, monthFrom: 5, yearTo: 1994, monthTo: 3 },
      { yearFrom: 2000, monthFrom: 4, yearTo: null, monthTo: null },
      { yearFrom: 1990, monthFrom: 9, yearTo: 1995, monthTo: null },
      { yearFrom: 1993, monthFrom: null, yearTo: null, monthTo: null },
      { yearFrom: 1989, monthFrom: null, yearTo: 1989, monthTo: 8 }
    ]
  });

  assert.deepEqual(thing.get("sortedEducations"), [
    { yearFrom: 2000, monthFrom: 4, yearTo: null, monthTo: null },
    { yearFrom: 1993, monthFrom: 2, yearTo: null, monthTo: null },
    { yearFrom: 1993, monthFrom: null, yearTo: null, monthTo: null },
    { yearFrom: 1990, monthFrom: 9, yearTo: 1995, monthTo: 2 },
    { yearFrom: 1990, monthFrom: 9, yearTo: 1995, monthTo: null },
    { yearFrom: 1990, monthFrom: 5, yearTo: 1994, monthTo: 3 },
    { yearFrom: 1990, monthFrom: 5, yearTo: 1994, monthTo: null },
    { yearFrom: 1989, monthFrom: 4, yearTo: 1989, monthTo: 8 },
    { yearFrom: 1989, monthFrom: null, yearTo: 1989, monthTo: 8 }
  ]);
});

test("it recomputes on changes", function(assert) {
  const Thing = EmberObject.extend({
    sortedEducations: sortByYear("educations")
  });

  const thing = Thing.create({
    educations: [
      { yearFrom: 1994, monthFrom: 4, yearTo: 2000, monthTo: 1 },
      { yearFrom: 1993, monthFrom: 2, yearTo: null, monthTo: null },
      { yearFrom: 1994, monthFrom: 6, yearTo: 1999, monthTo: 3 }
    ]
  });

  assert.deepEqual(thing.get("sortedEducations"), [
    { yearFrom: 1993, monthFrom: 2, yearTo: null, monthTo: null },
    { yearFrom: 1994, monthFrom: 4, yearTo: 2000, monthTo: 1 },
    { yearFrom: 1994, monthFrom: 6, yearTo: 1999, monthTo: 3 }
  ]);

  thing.set("educations", [
    { yearFrom: 1994, monthFrom: 3, yearTo: 2000, monthTo: 6 },
    { yearFrom: 1993, monthFrom: 6, yearTo: 2001, monthTo: 9 },
    { yearFrom: 1994, monthFrom: 8, yearTo: 1999, monthTo: 11 }
  ]);

  assert.deepEqual(thing.get("sortedEducations"), [
    { yearFrom: 1993, monthFrom: 6, yearTo: 2001, monthTo: 9 },
    { yearFrom: 1994, monthFrom: 3, yearTo: 2000, monthTo: 6 },
    { yearFrom: 1994, monthFrom: 8, yearTo: 1999, monthTo: 11 }
  ]);

  set(thing.get("educations")[0], "yearTo", 1991);
  set(thing.get("educations")[0], "monthTo", 4);

  assert.deepEqual(thing.get("sortedEducations"), [
    { yearFrom: 1993, monthFrom: 6, yearTo: 2001, monthTo: 9 },
    { yearFrom: 1994, monthFrom: 8, yearTo: 1999, monthTo: 11 },
    { yearFrom: 1994, monthFrom: 3, yearTo: 1991, monthTo: 4 }
  ]);

  set(thing.get("educations")[1], "yearTo", null);
  set(thing.get("educations")[1], "monthTo", null);

  assert.deepEqual(thing.get("sortedEducations"), [
    { yearFrom: 1993, monthFrom: 6, yearTo: null, monthTo: null },
    { yearFrom: 1994, monthFrom: 8, yearTo: 1999, monthTo: 11 },
    { yearFrom: 1994, monthFrom: 3, yearTo: 1991, monthTo: 4 }
  ]);
});
