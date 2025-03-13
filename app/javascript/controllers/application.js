import { Application } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap";

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Configure Boostrap tooltip
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

export { application }
