import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {
    static targets = ['dropdown'];

    static values = {
        autoWidth: { type: Boolean, default: false },
        contentPosition: { type: String, default: 'absolute' },
        multiple: { type: Boolean, default: false },
        placeholderText: { type: String, default: '' },
        hideSelected: { type: Boolean, default: false },
        clearText: { type: Boolean, default: false }
    };

    connect() {
        if (!this.hasDropdownTarget) return;

        this.orderedSelection = [];
        this.abortController = new AbortController();
        const { signal } = this.abortController;

        // We attach global listeners so we can react to SlimSelect internal input changes
        document.addEventListener('input', this.handleInput.bind(this), { signal });
        document.addEventListener('keydown', this.handleKeydown.bind(this), { signal });

        this.slim = this.createSlimSelect();


        if (this.multipleValue) {
            // We track selection order manually because SlimSelect doesn't remove the last selected natively
            this.orderedSelection = this.slim.getSelected();
        }

        // Makes dropdowns with link accessible by not routing if you click the closed dropdown
        if (this.slim.getSelected()?.[0]?.startsWith('/')) {
            const linkTag = document.querySelector('.ss-main .dropdown-option-link');
            if (linkTag) linkTag.href = 'javascript:void(0)';
        }
    }

    disconnect() {
        this.abortController?.abort();
        clearTimeout(this.highlightTimeout);
    }

    createSlimSelect() {
        return new SlimSelect({
            select: this.dropdownTarget,
            settings: {
                contentPosition: this.contentPositionValue,

                // Forces rules only when it needs to handle multiple select options
                ...(this.multipleValue && {
                    allowDeselect: true,
                    closeOnSelect: false,
                    keepOrder: true,
                    hideSelected: this.hideSelectedValue,
                    searchPlaceholder: 'Search... (Use backspace to deselect)',

                    ...(this.hasPlaceholderTextValue && { placeholderText: this.placeholderTextValue })
                })
            },
            events: {
                // After dropdown opens we immediately force highlight on first visible option
                afterOpen: () => this.highlightFirstVisibleOption(),

                // Normalize both strings so spaces/case don't matter
                searchFilter: (option, search) => {
                    const normalize = (str) => str.toLowerCase().replace(/\s/g, '');
                    return normalize(option.text).includes(normalize(search));
                },

                // If an option is actually a link, we navigate instead of selecting
                beforeChange: ([item]) => {
                    if (item?.html?.startsWith('<a')) {
                        Turbo.visit(item.value);
                        return false;
                    }
                    return true;
                },

                afterChange: (newVal) => this.handleAfterChange(newVal)
            }
        });
    }

    handleInput(event) {
        if (event.target === this.searchInput) this.highlightFirstVisibleOption();
    }

    handleKeydown(event) {
        const input = this.searchInput;
        if (
            !this.multipleValue || !input || document.activeElement !== input ||
            event.key !== 'Backspace' || input.value !== '' || !this.orderedSelection.length
        ) return;

        event.preventDefault();

        // We remove last selected item manually
        this.slim.setSelected(this.orderedSelection.slice(0, -1));
    }

    handleAfterChange(newVal) {
        const currentValues = newVal.map(opt => opt.value);

        const existing = this.orderedSelection.filter(v => currentValues.includes(v));
        const added = currentValues.filter(v => !this.orderedSelection.includes(v));

        this.orderedSelection = [...existing, ...added];

        if (!this.multipleValue) return;

        setTimeout(() => {
            const input = this.searchInput;
            if (!input) return;

            if (this.clearTextValue) input.value = '';

            input.dispatchEvent(new Event('input', {bubbles: true}));

            input.focus();

            this.highlightFirstVisibleOption();
        }, 10);
    }

    get searchInput() {
        return document.querySelector('.ss-open-below input, .ss-open-above input');
    }

    highlightFirstVisibleOption() {
        clearTimeout(this.highlightTimeout);

        this.highlightTimeout = setTimeout(() => {
            const options = Array.from(
                document.querySelectorAll('.ss-open-below .ss-option, .ss-open-above .ss-option')
            ).filter(el => !el.classList.contains('ss-hide') && el.style.display !== 'none');

            if (!options.length) return;

            document.querySelectorAll('.ss-option.ss-highlighted')
                .forEach(el => el.classList.remove('ss-highlighted'));

            options[0].classList.add('ss-highlighted');
        }, 100); // We need this to eliminate the highlight form getting of the first object.
    }

    navigateOnChange(event) {
        window.location.href = event.target.value;
    }
}