import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="people-skills-filter"
export default class extends Controller {
    static targets = ["filter", "form"]

    remove({params}) {
        this.filterTargets[params.id].remove();
        this.formTarget.submit();
    }
}
