import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    connect() {
        const params = new URLSearchParams(window.location.search);
        if(params.has("q")) {
            document.getElementById("cv_search_field").value = params.get("q");
        }
        if(params.has("search_skills")) {
            document.getElementById("search_skills_checkbox").checked = true;
        }
    }

    timeout;
    submitWithTimeout(e) {
        const form = e.target.parentElement;
        clearTimeout(this.timeout);
        this.timeout = setTimeout(() => {
            form.requestSubmit();
        }, 100)
    }
}