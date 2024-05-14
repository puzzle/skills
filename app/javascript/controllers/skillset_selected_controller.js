import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="skillset-selected"
export default class extends Controller {
    static targets = ["selectButton"];
    selectedButton = null;

    selectButton({params}) {
        if(this.selectedButton != null) {
            this.selectButtonTargets[this.selectedButton].classList.remove("btn-primary");
            this.selectButtonTargets[this.selectedButton].classList.remove("text-white");
        }
        this.selectedButton = params.id;
        this.selectButtonTargets[params.id].classList.add("btn-primary");
        this.selectButtonTargets[params.id].classList.add("text-white");
    }
}