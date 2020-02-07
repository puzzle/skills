import classic from "ember-classic-decorator";
import { computed } from "@ember/object";
import Component from "@ember/component";

@classic
export default class CompetenceNotesShow extends Component {
  @computed("person.competenceNotes")
  get competenceNotesList() {
    let competences = this.get("person.competenceNotes");
    if (competences == null) return "";
    return competences.split("\n");
  }

  removeEmptyStrings(array) {
    for (let i = array.length; i--; ) {
      if (array[i] == "") array.splice(i, 1);
    }
    return array;
  }
}
