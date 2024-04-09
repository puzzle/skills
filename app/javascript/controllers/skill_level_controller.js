import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['switch', 'label']
    levels = {"1": "Trainee", "2": "Junior", "3": "Professional", "4": "Senior", "5": "Expert"}

    toggleLevel() {
        this.labelTarget.textContent = this.levels[this.switchTarget.value]
    }
}