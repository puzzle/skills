import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['container', 'switch', 'label']
    levels = {"1": "Trainee", "2": "Junior", "3": "Professional", "4": "Senior", "5": "Expert"}
    showSwitch = false;

    connect() {
        this.toggleSwitch();
    }

    toggleSwitch() {
        this.containerTarget.style.display = !this.showSwitch  ? 'none' : 'block';
        this.showSwitch = !this.showSwitch
    }

    toggleLevel() {
        this.labelTarget.textContent = this.levels[this.switchTarget.value]
    }
}