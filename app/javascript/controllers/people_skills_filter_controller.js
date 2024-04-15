import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="people-skills-filter"
export default class extends Controller {
    static targets = ["filter"]

    connect() {
        console.log("Fuck my life")
    }

    hide({params}) {
        this.filterTargets[params.id - 1].style.display = "none";
    }
}
