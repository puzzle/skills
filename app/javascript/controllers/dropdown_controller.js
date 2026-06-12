import {Controller} from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

export default class extends Controller {
    static targets = ["dropdown"]
    static values = {
        autoWidth: {type: Boolean, default: false},
        contentPosition:  {type: String, default: 'absolute'},
        multiple: { type: Boolean, default: false },
        placeholderText: { type: String, default: "" }
    }

    connect() {
        if (!this.hasDropdownTarget) return;

        const settings = {
            contentPosition: this.contentPositionValue,
        };

        if (this.multipleValue) {
            settings.allowDeselect = true;
            settings.closeOnSelect = false;
            if (this.hasPlaceholderTextValue) {
                settings.placeholderText = this.placeholderTextValue;
            }
        }

        // Because when reloading, a different value is selected instead of the one that was previously selected
        const originalSelectedOption = Array.from(this.dropdownTarget.options).find(opt => opt.defaultSelected);
        if (originalSelectedOption) {
            this.dropdownTarget.value = originalSelectedOption.value;
        }

        this.slimSelectDropdown = new SlimSelect({
            select: this.dropdownTarget,
            settings: settings,
            events: {
                searchFilter: (option, search) => {
                    return option.text.toLowerCase().replace(/\s/g, '').indexOf(search.toLowerCase().replace(/\s/g, '')) !== -1
                },
                beforeChange: (newVal) => {
                    const item = newVal[0];

                    // Check if dropdown element is a link
                    if (item?.html?.startsWith("<a")) {
                        Turbo.visit(item.value);

                        return false;
                    }
                    return true;
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