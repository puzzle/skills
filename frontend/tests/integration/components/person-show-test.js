import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";

module("Integration | Component | person show", function(hooks) {
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
      department: this.department,
      company: this.company,
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
        role: this.role,
        level: "S1",
        personRoleLevel: this.personRoleLevel,
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

    assert.ok(this.element.textContent.includes("Harry Potter"));
    assert.ok(this.element.textContent.includes("harry@hogwarts.com"));
    assert.ok(this.element.textContent.includes("HP"));
    assert.ok(this.element.textContent.includes("Zauberer"));
    assert.ok(this.element.textContent.includes("König"));
    assert.ok(this.element.textContent.includes("S1"));
    assert.ok(this.element.textContent.includes("60%"));
    assert.ok(this.element.textContent.includes("/sys"));
    assert.ok(this.element.textContent.includes("Bewerber"));
    assert.ok(this.element.textContent.includes("01.01.2000"));
    assert.ok(this.element.textContent.includes("Frankreich"));
    assert.ok(this.element.textContent.includes("Hogwarts"));
    assert.ok(this.element.textContent.includes("ledig"));
    assert.ok(this.element.textContent.includes("DE"));
  });
});
