import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["message"]

    remove() {
        this.messageTarget.remove();
    }
}