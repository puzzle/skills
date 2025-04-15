import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    submitAsChecked() {
        document.getElementById('checked-conflicts-field').value = true;
        document.getElementById('unify-skills-form').requestSubmit();
    }
}