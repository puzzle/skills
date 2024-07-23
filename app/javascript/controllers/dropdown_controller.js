import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  static targets = [ "dropdown" ]
  connect() {
    new SlimSelect({
          select: this.dropdownTarget
    });
  }

  handleChange(event) {
      const params = window.location.search
      window.location.href = event.target.value + params;
  }
}
