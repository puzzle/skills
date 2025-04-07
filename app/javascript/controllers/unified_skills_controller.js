import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['checkedConflictsField', 'submitButton', 'checkButton'];
    markAsUnchecked() {
        this.checkedConflictsFieldTarget.value = false;
        this.submitButtonTarget.hidden = true;
        this.checkButtonTarget.hidden = false;
    }
}