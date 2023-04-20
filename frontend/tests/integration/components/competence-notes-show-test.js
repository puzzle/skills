import hbs from "htmlbars-inline-precompile";
import { module, test } from "qunit";
import { run } from "@ember/runloop";
import { setupRenderingTest } from "ember-qunit";
import keycloakStub from "../../helpers/keycloak-stub";
import { render } from "@ember/test-helpers";
import { setLocale } from "ember-intl/test-support/index";

module(
  "competence-notes-show",
  "Integration | Component | competence-notes-show",
  function(hooks) {
    setupRenderingTest(hooks);

    hooks.beforeEach(function(assert) {
      this.owner.register("service:keycloak-session", keycloakStub);
      setLocale("de");
    });

    test("it renders competences from person", async function(assert) {
      let person = run(() =>
        this.owner.lookup("service:store").createRecord("person")
      );
      person.competenceNotes = "Ruby\nJava\nJavascript";
      this.set("person", person);

      await render(hbs`{{competence-notes-show person=person}}`);

      // doesn't show full person
      assert.dom("#competence-content-show", document).includesText("Ruby");
      assert.dom("#competence-content-show", document).includesText("Java");
      assert
        .dom("#competence-content-show", document)
        .includesText("Javascript");
    });
  }
);
