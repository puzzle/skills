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

    redirectWithParams(e) {
        e.preventDefault();
        const href = e.target.href;
        const params = new URLSearchParams(window.location.search);
        window.location.href = href + "?" + params;
    }
}