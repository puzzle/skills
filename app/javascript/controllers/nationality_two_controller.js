import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    setVisibility() {
        const natTwoElements = document.getElementsByClassName('nationality-two')
        const natTwoCheckbox = document.getElementById('nat-two-checkbox')
        for(const element of natTwoElements) {
            !natTwoCheckbox.checked ? element.classList.add('d-none') : element.classList.remove('d-none')
        }
    }

    connect() {
        this.setVisibility();
    }
    nationalityTwoVisible() {
        this.setVisibility()
    }
}