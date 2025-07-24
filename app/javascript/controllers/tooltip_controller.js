import {Controller} from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

export default class extends Controller {
    connect() {
        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
    }

    hide(event) {
        const element = event.currentTarget;
        const tooltip = bootstrap.Tooltip.getInstance(element);
        tooltip.hide();
    }
}
