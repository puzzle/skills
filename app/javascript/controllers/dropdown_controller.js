import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  static targets = [ "dropdown" ]
  connect() {
    if (!this.hasDropdownTarget)
      return;
    
    new SlimSelect({
          select: this.dropdownTarget
    });
  }

  handleChange(event) {
      window.location.href = event.target.value;
  }
}
