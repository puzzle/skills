import { Controller } from "@hotwired/stimulus"
import Choices from 'choices.js';

// Connects to data-controller="dropdown-links"
export default class extends Controller {

  connect() {
    const element = document.getElementById('dropdown');
    let choices = new Choices(element, {
      searchResultLimit: 50,
      allowHTML: true,
      searchFloor: 2,
      // See "classNames" in the huge setup-code for all classes: https://github.com/Choices-js/Choices?tab=readme-ov-file#setup
      classNames: {
        highlightedState: 'dropdown-option-highlighted',
      },
      fuseOptions: {
        threshold: 0.2
      }
    });
  }

  disconnect() {
    window.addEventListener("popstate", () => {
      window.location.reload();
    });
  }

  handleChange(event) {
      window.location.href = event.target.dataset.value + event.target.value;
  }
}
