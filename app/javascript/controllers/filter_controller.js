import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="skillset-selected"
export default class extends Controller {

    submit() {
        const form = this.element;
        const formData = new FormData(form);
    
        const params = new URLSearchParams(formData);
        const newUrl = `${form.action}?${params.toString()}`;
        history.pushState({}, "", newUrl);
    }
}