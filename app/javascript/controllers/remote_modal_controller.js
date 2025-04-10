import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
    connect() {
        this.modal = new Modal(this.element);
        this.modal.show();
        this.element.classList.toggle('fader');
    }

    disconnect() {
        this.element.classList.remove('fader');
    }

    isOpen() {
        return this.element.classList.contains("show")
    }
}