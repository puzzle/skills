import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  static targets = [ "dropdown" ]
  connect() {
    if (!this.hasDropdownTarget)
      return;
    
    new SlimSelect({
      select: this.dropdownTarget,
      events: {
        beforeChange: (newVal) => {
          newVal = newVal[0];

          // Check if dropdown element is a link
          if(newVal.html.startsWith("<a")) {
            Turbo.visit(newVal.value);
            return false;
          }
        }
      },
    });
  }

  handleChange(e) {
    Turbo.visit(e.target.value);
  }
}
