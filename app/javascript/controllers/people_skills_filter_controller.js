import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="people-skills-filter"
export default class extends Controller {
    static targets = ["filter", "add"]

    connect() {
        for(let target of this.filterTargets) {
            target.style.display = "none";
        }
    }

    hide({params}) {
        this.filterTargets[params.id - 1].style.display = "none";
        this.addTarget.style.display = "flex";
    }

    show() {
        for(let target of this.filterTargets) {
            if(target.style.display === "none") {
                target.style.display = "block";
                if(target === this.filterTargets[this.filterTargets.length - 1]) {
                    this.addTarget.style.display = "none";
                }
                return;
            }
        }
    }
}
