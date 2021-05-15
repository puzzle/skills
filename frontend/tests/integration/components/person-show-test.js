import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("person-show", "Integration | Component | person show", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders person", async function(assert) {
    this.set("company", {
      name: "Bewerber"
    });

    this.set("department", {
      name: "/sys"
    });

    this.set("personRoleLevel", {
      id: "1",
      level: "S1"
    });

    this.set("person", {
      name: "Harry Potter",
      email: "harry@hogwarts.com",
      shortname: "HP",
      title: "Zauberer",
      department: this.get("department"),
      company: this.get("company"),
      birthdate: new Date("2000-01-01"),
      nationality: "FR",
      location: "Hogwarts",
      maritalStatus: "single"
    });

    this.set("role", {
      name: "König"
    });

    this.set("person.personRoles", [
      {
        role: this.get("role"),
        level: "S1",
        personRoleLevel: this.get("personRoleLevel"),
        percent: 60
      }
    ]);

    this.set("person.languageSkills", [
      {
        language: "DE",
        level: "A1",
        certificate: ""
      }
    ]);

    await render(hbs`{{person-show person=person}}`);

    assert.ok(this.element.textContent.trim().includes("Harry Potter"));
    assert.ok(this.element.textContent.trim().includes("harry@hogwarts.com"));
    assert.ok(this.element.textContent.trim().includes("HP"));
    assert.ok(this.element.textContent.trim().includes("Zauberer"));
    assert.ok(this.element.textContent.trim().includes("König"));
    assert.ok(this.element.textContent.trim().includes("S1"));
    assert.ok(this.element.textContent.trim().includes("60%"));
    assert.ok(this.element.textContent.trim().includes("/sys"));
    assert.ok(this.element.textContent.trim().includes("Bewerber"));
    assert.ok(this.element.textContent.trim().includes("01.01.2000"));
    assert.ok(this.element.textContent.trim().includes("Frankreich"));
    assert.ok(this.element.textContent.trim().includes("Hogwarts"));
    assert.ok(this.element.textContent.trim().includes("ledig"));
    assert.ok(this.element.textContent.trim().includes("DE"));
  });
});
