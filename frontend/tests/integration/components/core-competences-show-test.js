import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import Service from "@ember/service";

const storeStub = Service.extend({
  query(type, options) {
    return new Promise(function(resolve, reject) {
      resolve({
        toArray() {
          return [
            {
              get(attr) {
                let val;
                if (attr == "title") {
                  val = "Software Engineering";
                } else {
                  val = [
                    {
                      get(attr) {
                        return 1;
                      },
                      title: "Ruby"
                    },
                    {
                      get(attr) {
                        return attr == "id" ? 2 : "Java";
                      }
                    }
                  ];
                }
                return val;
              }
            }
          ];
        }
      });
      reject(undefined);
    });
  }
});

module("Integration | Component | core-competences-show", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders", async function(assert) {
    this.set("person", {
      peopleSkills: [
        {
          get(attr) {
            let val;
            if (attr == "coreCompetence") {
              val = true;
            } else {
              val = {
                get(attr) {
                  return 1;
                }
              };
            }
            return val;
          }
        },
        {
          get(attr) {
            let val;
            if (attr == "coreCompetence") {
              val = false;
            } else {
              val = {
                get(attr) {
                  return 2;
                }
              };
            }
            return val;
          }
        }
      ]
    });

    this.owner.register("service:store", storeStub);

    await render(hbs`{{core-competences-show person=person}}`);

    let text = this.$().text();

    assert.ok(text.includes("Software Engineering"));
    assert.ok(text.includes("Ruby"));
    assert.notOk(text.includes("Java"));
  });
});
