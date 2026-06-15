import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    connect() {
        const params = new URLSearchParams(window.location.search);
        if(params.has("q")) {
            document.getElementById("cv_search_field").value = params.get("q");
            this.whitespaceCheckbox();
        }
        if(params.has("search_skills")) {
            document.getElementById("search_skills_checkbox").checked = true;
        }
    }

    timeout;
    submitWithTimeout(e) {
        this.whitespaceCheckbox()
        const form = e.target.parentElement;
        clearTimeout(this.timeout);
        this.timeout = setTimeout(() => {
            form.requestSubmit();
        }, 200)
    }

    whitespaceCheckbox(){
        const includesWhitespace =  document.getElementById("cv_search_field").value.includes(" ")
        document.getElementById("handle_whitespaces_checkbox").disabled = !includesWhitespace;
        if (!includesWhitespace){
            document.getElementById("handle_whitespaces_checkbox").value = false;
        }
    }
}