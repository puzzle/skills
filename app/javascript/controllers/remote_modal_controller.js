import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
    connect() {
        this.modal = new Modal(this.element);
        this.modal.show();
    }

    disconnect() {
        this.modal.dispose();
    }

    isOpen() {
        return this.element.classList.contains("show")
    }
}

//Before caching dispose the modal else we can't interact with the page after it was loaded from the cache.
document.addEventListener("turbo:before-cache", () => {
    this.modal.dispose();
});