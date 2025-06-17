import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['message']

    connect() {
        this.messageTarget.style.display = 'none';
    }

    showMessage() {
        this.messageTarget.style.display = 'block';
    }
}