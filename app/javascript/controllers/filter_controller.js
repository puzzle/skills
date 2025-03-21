import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {

    submit() {
        const form = this.element;
        const formData = new FormData(form);
    
        const params = new URLSearchParams(formData);
        const newUrl = `${form.action}?${params.toString()}`;

        /* When changing the rating filter, the action urls of the default skill forms don't reflect that change.
        To prevent reverting the filter to its state when initially loading the page, we have to update the rating
        param in the action urls of these forms. */
        const defaultSkillForms = document.querySelectorAll('#default-skills form');
        defaultSkillForms.forEach(f => f.action = newUrl)

        history.pushState({}, "", newUrl);
    }
}