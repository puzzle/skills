import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {
    static targets = ["dropdown"]
    static values = {
        autoWidth: { type: Boolean, default: false },
        contentPosition:  { type: String, default: 'absolute' },
        multiple: { type: Boolean, default: false },
        placeholderText: { type: String, default: "" }
    }

    connect() {
        if (!this.hasDropdownTarget) return;

        this.sortOptions();

        const settings = {
            contentPosition: this.contentPositionValue,
        };

        if (this.multipleValue) {
            settings.allowDeselect = true;
            settings.closeOnSelect = false;
            settings.hideSelected = true;

            if (this.hasPlaceholderTextValue) {
                settings.placeholderText = this.placeholderTextValue;
            }
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

                    if (item?.html?.startsWith("<a")) {
                        Turbo.visit(item.value);
                        return false;
                    }
                    return true;
                },
                afterChange: () => {
                    if (this.multipleValue) {
                        setTimeout(() => {
                            const searchInput = this.element.querySelector('.ss-search input');
                            if (searchInput) {
                                searchInput.value = '';
                                searchInput.dispatchEvent(new Event('input', { bubbles: true }));
                                searchInput.focus();
                            }
                        }, 10);
                    }
                }
            },
        });

        // Make currently selected element not follow link when clicked on, so opening the dropdown is possible
        if(slimSelectDropdown.getSelected()[0]?.startsWith("/")) {
            const linkTag = document.querySelector('.ss-main .dropdown-option-link');
            if (linkTag) linkTag.href = "javascript:void(0)";
        }
    }

    sortOptions() {
        const select = this.dropdownTarget;
        const options = Array.from(select.options);

        const placeholder = options.find(opt => opt.value === "");
        const sortableOptions = options.filter(opt => opt.value !== "");

        sortableOptions.sort((a, b) => a.text.localeCompare(b.text));

        select.innerHTML = '';
        if (placeholder) select.appendChild(placeholder);
        sortableOptions.forEach(opt => select.appendChild(opt));
    }

    navigateOnChange(event) {
        window.location.href = event.target.value;
    }
}