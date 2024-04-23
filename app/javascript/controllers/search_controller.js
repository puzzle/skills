import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    timeout;
    submitWithTimeout(e) {
        const form = e.target.parentElement;
        clearTimeout(this.timeout);
        this.timeout = setTimeout(() => {
            form.requestSubmit();
        }, 400)
    }
}