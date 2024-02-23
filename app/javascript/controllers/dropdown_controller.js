import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  connect() {}

    handleChange(event) {
        window.location.href = event.target.dataset.value + event.target.value;
    }
}
