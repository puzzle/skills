import hbs from "htmlbars-inline-precompile";
import { module, test } from "qunit";

module("or", "Integration | Helper | or", function() {
  test("it works", function(assert) {
    this.render(hbs`{{or 0 1}}`);

    assert.equal(
      this.$()
        .text()
        .trim(),
      "1"
    );

    this.render(hbs`{{or 1 0}}`);

    assert.equal(
      this.$()
        .text()
        .trim(),
      "1"
    );

    this.render(hbs`{{or 0 false 'hallo'}}`);

    assert.equal(
      this.$()
        .text()
        .trim(),
      "hallo"
    );
  });
});
