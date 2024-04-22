import { Controller } from "@hotwired/stimulus"
import Choices from 'choices.js';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  connect() {
    const element = document.getElementById('dropdown');
    const choices = new Choices(element, {
      searchResultLimit: 50,
      searchFloor: 2,
      fuseOptions: {
        threshold: 0.2
      },
    });
  }

  handleChange(event) {
      window.location.href = event.target.dataset.value + event.target.value;
  }
}
