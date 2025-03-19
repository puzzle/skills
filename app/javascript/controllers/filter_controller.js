import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {

    submit() {
        const form = this.element;
        const formData = new FormData(form);
    
        const params = new URLSearchParams(formData);
        const newUrl = `${form.action}?${params.toString()}`;

        const defaultSkillForms = document.querySelectorAll('#default-skills form');
        defaultSkillForms.forEach(f => f.action = newUrl)

        history.pushState({}, "", newUrl);
    }
}