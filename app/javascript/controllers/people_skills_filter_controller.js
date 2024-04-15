import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="people-skills-filter"
export default class extends Controller {
    static targets = ["filter", "add"]
    filterCounter = 3;

    connect() {
        console.log("Fuck my life")
    }

    hide({params}) {
        this.filterTargets[params.id - 1].style.display = "none";
        this.filterCounter--;
    }

    show() {
        this.filterTargets[this.filterCounter].style.display = "block";
        this.filterCounter++;
        if(this.filterCounter === 3) {
            this.addTarget.style.display = "none";
        }
    }
}
