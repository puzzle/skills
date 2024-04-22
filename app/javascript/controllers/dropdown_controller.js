import { Controller } from "@hotwired/stimulus"
import Choices from 'choices.js';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  connect() {
    const element = document.getElementById('dropdown');
    const choices = new Choices(element, {
      searchResultLimit: 8,
      searchFloor: 2,
    });
  }

  handleChange(event) {
      window.location.href = event.target.dataset.value + event.target.value;
  }
}
