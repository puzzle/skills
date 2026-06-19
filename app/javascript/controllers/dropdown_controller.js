import {Controller} from "@hotwired/stimulus"
import SlimSelect from "slim-select"

// Connects to data-controller="dropdown-links"
export default class extends Controller {
    static targets = ["dropdown"]
    static values = {
        autoWidth: { type: Boolean, default: false },
        contentPosition: { type: String, default: 'absolute' },
        multiple: { type: Boolean, default: false },
        placeholderText: { type: String, default: "" },
        hideSelected: { type: Boolean, default: false },
        clearText: { type: Boolean, default: false }
    }

    connect() {
        if (!this.hasDropdownTarget) return;

        const settings = {
            contentPosition: this.contentPositionValue,
        };

        if (this.multipleValue) {
            settings.allowDeselect = true;
            settings.closeOnSelect = false;
            settings.hideSelected = this.hideSelectedValue;

            if (this.hasPlaceholderTextValue) {
                settings.placeholderText = this.placeholderTextValue;
            }
        }

        const slimSelectDropdown = new SlimSelect({
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
                },

                afterChange: () => {
                    if (this.multipleValue) {
                        setTimeout(() => {
                            const searchInput = document.querySelector('.ss-open-below input');

                            if (searchInput) {
                                if (this.clearTextValue) {
                                    searchInput.value = ''
                                }
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

        if (this.multipleValue) {
            document.addEventListener("keydown", (event) => {
                const searchInput = document.querySelector(".ss-open-below input")
                if (!searchInput || document.activeElement !== searchInput || event.key !== "Backspace" || searchInput.value !== "") {
                    return
                }
                const selected = slimSelectDropdown.getSelected()
                if (selected.length > 0) {
                    event.preventDefault()
                    slimSelectDropdown.setSelected(selected.slice(0, -1))
                }
            })
        }

        if (slimSelectDropdown.getSelected()[0]?.startsWith("/")) {
            const linkTag = document.querySelector(
                '.ss-main .dropdown-option-link'
            );

            if (linkTag) {
                linkTag.href = "javascript:void(0)";
            }
        }
    }

    navigateOnChange(event) {
        window.location.href = event.target.value;
    }
}