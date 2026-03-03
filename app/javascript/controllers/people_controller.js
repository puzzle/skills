import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["message"]

    remove(event) {
        event.preventDefault();
        this.element.remove();
    }
}