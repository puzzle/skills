import {Controller} from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
    static targets = ["dropdown"]
    static values = {
        autoWidth: { type: Boolean, default: false },
        contentPosition: { type: String, default: 'absolute' },
        multiple: { type: Boolean, default: false },
        placeholderText: { type: String, default: "" },
        hideSelected: { type: Boolean, default: false }
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
        Array.from(this.dropdownTarget.options).forEach(opt => {
            opt.selected = opt.defaultSelected;
        });

        this.slimSelectDropdown = new SlimSelect({
            select: this.dropdownTarget,
            settings: settings,
            events: {
                searchFilter: (option, search) => {
                    return option.text
                        .toLowerCase()
                        .replace(/\s/g, '')
                        .indexOf(
                            search.toLowerCase().replace(/\s/g, '')
                        ) !== -1;
                },
                beforeChange: (newVal) => {
                    const item = newVal[0];

                    // Check if dropdown element is a link
                    if (item?.html?.startsWith("<a")) {
                        Turbo.visit(item.value);

                        return false;
                    }
                    return true;
                    return true;
                },
                afterChange: () => {
                    if (this.multipleValue) {
                        setTimeout(() => {
                            const searchInput = this.element.querySelector('.ss-search input');
                            if (searchInput) {
                                searchInput.value = '';
                                searchInput.dispatchEvent(
                                    new Event('input', { bubbles: true })
                                );
                                searchInput.focus();
                            }
                        }, 10);
                    }
                }
            },
        });
        if(slimSelectDropdown.getSelected()[0]?.startsWith("/")) {
            const linkTag = document.querySelector('.ss-main .dropdown-option-link');
            if (linkTag) linkTag.href = "javascript:void(0)";
        }
    }

    navigateOnChange(event) {
        window.location.href = event.target.value;
    }
}