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
        this.filterTargets[params.id].style.display = "none";
        this.addTarget.style.display = "flex";
    }

    show() {
        for(let target of this.filterTargets) {
            if(target.style.display === "none") {
                target.style.display = "block";
                if(this.countHidden() === this.filterTargets.length) {
                    this.addTarget.style.display = "none";
                }
                return;
            }
        }
    }

    countHidden() {
        return this.filterTargets.filter(x => x.style.display === "block").length;
    }
}
