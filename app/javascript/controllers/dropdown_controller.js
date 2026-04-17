import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
    static targets = ["dropdown"]
    static values = {
        autoWidth: {type: Boolean, default: false},
        contentPosition:  {type: String, default: 'absolute'},
        multiple: { type: Boolean, default: false }
    }

    connect() {
        if (!this.hasDropdownTarget) return;

        if (this.multipleValue) {
            this.dropdownTarget.setAttribute("multiple", "multiple");
        }

        const slimSelectDropdown = new SlimSelect({
            select: this.dropdownTarget,
            settings: {
                contentPosition: this.contentPositionValue,
            },
            events: {
                searchFilter: (option, search) => {
                    return option.text.toLowerCase().replace(/\s/g, '').includes(search.toLowerCase().replace(/\s/g, ''))
                },
                beforeChange: (newVal) => {
                    newVal = newVal[0];
                    const item = newVal?.[0];

                    // Check if dropdown element is a link
                    if(item?.html?.startsWith("<a")) {
                        Turbo.visit(item.value);

                        return false;
                    }
                    return true;
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
