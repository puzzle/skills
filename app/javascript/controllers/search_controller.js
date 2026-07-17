import {Controller} from "@hotwired/stimulus"

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
            this.checkInputForEasterEggs(e.target.value)
            form.requestSubmit();
        }, 200)
    }

    whitespaceCheckbox() {
        const includesWhitespace = document.getElementById("cv_search_field").value.includes(" ")
        document.getElementById("handle_whitespaces_checkbox").disabled = !includesWhitespace;
    }

    checkInputForEasterEggs(value) {
        const backgroundColor = value === "jeb_" ?  "linear-gradient(in hsl longer hue 45deg, red 0 100%)" : ""
        const rotation = value === "Dinnerbone" ? 180 : 0
        Object.assign(document.body.style, {
            transform: `rotate(${rotation}deg)`,
            transformOrigin: "center",
        });
        document.querySelectorAll(".bg-body").forEach(el => {
            el.style.backgroundImage = backgroundColor;
        });
    }
}