import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  static targets = [ "dropdown" ]
  connect() {
    if (!this.hasDropdownTarget)
      return;
    
    const slimSelectDropdown = new SlimSelect({
      select: this.dropdownTarget,
      events: {
        beforeChange: (newVal) => {
          newVal = newVal[0];

          // Check if dropdown element is a link
          if(newVal.html.startsWith("<a")) {
            Turbo.visit(newVal.value);

            // Make currently selected element not follow link when clicked on, so opening the dropdown is possible
            if(slimSelectDropdown.getSelected()[0]) {
              document.querySelector('.ss-main .dropdown-option-link').href = "javascript:void(0)";
            }

            return false;
          }
        }
      },
    });

    // Make currently selected element not follow link when clicked on, so opening the dropdown is possible
    if(slimSelectDropdown.getSelected()[0]?.startsWith("/")) {
      document.querySelector('.ss-main .dropdown-option-link').href = "javascript:void(0)";
    }
  }

  navigateOnChange(event) {
    window.location.href = event.target.value;
  }
}
