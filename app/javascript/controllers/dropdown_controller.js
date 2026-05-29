import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
    static targets = ["dropdown"]
    static values = {
        autoWidth: {type: Boolean, default: false},
        contentPosition:  {type: String, default: 'absolute'}
    }

    connect() {
        if (!this.hasDropdownTarget)
            return;

        // Because when reloading, a different value is selected instead of the one that was previously selected
        const originalSelectedOption = Array.from(this.dropdownTarget.options).find(opt => opt.defaultSelected);
        if (originalSelectedOption) {
            this.dropdownTarget.value = originalSelectedOption.value;
        }

        this.slimSelectDropdown = new SlimSelect({
            select: this.dropdownTarget,
            settings: {
                contentPosition: this.contentPositionValue,
            },
            events: {
                searchFilter: (option, search) => {
                    return option.text.toLowerCase().replace(/\s/g, '').indexOf(search.toLowerCase().replace(/\s/g, '')) !== -1
                },
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

        // Make currently selected element not follow link when clicked on, so opening the dropdown is possible
        if(this.slimSelectDropdown.getSelected()[0]?.startsWith("/")) {
            document.querySelector('.ss-main .dropdown-option-link').href = "javascript:void(0)";
        }
    }

    disconnect() {
        if (this.slimSelectDropdown) {
            this.slimSelectDropdown.destroy();
        }
    }

    navigateOnChange(event) {
        window.location.href = event.target.value;
    }
}
