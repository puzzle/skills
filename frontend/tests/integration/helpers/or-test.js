import hbs from "htmlbars-inline-precompile";
import { module, test } from "qunit";

module("or", "Integration | Helper | or", function() {
  /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */

  test("it works", function(assert) {
    this.render(hbs`{{or 0 1}}`);

    assert.equal(
      $()
        .text()
        .trim(),
      "1"
    );

    this.render(hbs`{{or 1 0}}`);

    assert.equal(
      $()
        .text()
        .trim(),
      "1"
    );

    this.render(hbs`{{or 0 false 'hallo'}}`);

    assert.equal(
      $()
        .text()
        .trim(),
      "hallo"
    );
  });

  /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
});
