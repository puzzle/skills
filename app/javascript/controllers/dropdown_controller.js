import {Controller} from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {
    static targets = ['dropdown', 'refreshButton'];

    static values = {
        autoWidth: {type: Boolean, default: false},
        contentPosition: {type: String, default: 'absolute'},
        multiple: {type: Boolean, default: false},
        placeholderText: {type: String, default: ''},
        hideSelected: {type: Boolean, default: false},
        clearText: {type: Boolean, default: false},
        addLink: {type: String, default: ''},
        addLinkLabel: {type: String, default: ''}
    };

    get searchInput() {
        return document.querySelector('.ss-open-below input, .ss-open-above input');
    }

    get visibleOptions(){
        return Array.from(
            document.querySelectorAll('.ss-open-below .ss-option, .ss-open-above .ss-option')
        ).filter(el => !el.classList.contains('ss-hide') && el.style.display !== 'none');
    }

    connect() {
        if (!this.hasDropdownTarget) return;

        this.orderedSelection = [];
        this.listScrollPosition = 0;
        this.highlightedIndex = 0;
        this.abortController = new AbortController();
        const {signal} = this.abortController;

        // We attach global listeners so we can react to SlimSelect internal input changes
        document.addEventListener('input', this.handleInput.bind(this), {signal});
        document.addEventListener('keydown', this.handleKeydown.bind(this), {signal});

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

        this.configureOptionRefresh();
    }

    disconnect() {
        this.abortController?.abort();
        clearTimeout(this.highlightTimeout);

        if (this.slim) {
            this.slim.destroy();
        }
    }

    createSlimSelect() {
        return new SlimSelect({
            select: this.dropdownTarget,
            settings: this.slimSelectSettings(),
            events: {
                // After dropdown opens we immediately force highlight on first visible option
                afterOpen: () => this.highlightVisibleOption(),
                search: this.search.bind(this),
                beforeChange: this.beforeChange.bind(this),
                afterChange: this.afterChange.bind(this)
            }
        });
    }

    search(searchValue, selected, catalog){
        const normalize = (str) => str.toLowerCase().replace(/\s/g, '');
        const results = catalog.filter(option =>
            normalize(option.text).includes(normalize(searchValue))
        );

        if (this.addLinkValue && results.length === 0) {
            return this.addLinkOption(searchValue);
        }
        return results
    }

    beforeChange (newVal, oldVal) {
        const list = document.querySelector('.ss-list');
        if (list) {
            this.listScrollPosition = list.scrollTop;
        }

        const visibleOptions = this.visibleOptions

        const highlighted = document.querySelector('.ss-option.ss-highlighted');
        this.highlightedIndex = Math.max(0, visibleOptions.indexOf(highlighted));

        const selectedOption = newVal.find((option) => !oldVal?.includes(option));
        return this.navigateIfSelectedOptionIsALink(selectedOption)
    }

    afterChange(newVal) {
        const current = newVal.map(({value}) => value);

        const existing = this.orderedSelection.filter(value =>
            current.includes(value)
        );

        const added = current.filter(value =>
            !this.orderedSelection.includes(value)
        );

        this.orderedSelection = [...existing, ...added];

        if (!this.multipleValue) return;

        setTimeout(() => {
            const input = this.searchInput;
            if (!input) return;

            if (this.clearTextValue) input.value = '';

            input.dispatchEvent(new Event('input', {bubbles: true}));
            input.focus();

            this.highlightVisibleOption(this.highlightedIndex);

            const list = document.querySelector('.ss-list');
            if (list) {
                list.scrollTop = this.listScrollPosition;
            }

        }, 10);
    }

    handleInput(event) {
        if (event.target === this.searchInput) this.highlightVisibleOption(0);
    }

    handleKeydown(event) {
        const input = this.searchInput;
        if (
            this.multipleValue &&
            input &&
            document.activeElement === input &&
            event.key === 'Backspace' &&
            input.value === '' &&
            this.orderedSelection.length
        ) {
            event.preventDefault();
            // We remove last selected item manually
            this.slim.setSelected(this.orderedSelection.slice(0, -1));
        }
    }

    slimSelectSettings() {
        const base = {contentPosition: this.contentPositionValue};

        if (!this.multipleValue) return base; // Forces rules only when it needs to handle multiple select options

        return {
            ...base,
            allowDeselect: true,
            closeOnSelect: false,
            keepOrder: true,
            hideSelected: this.hideSelectedValue,
            searchPlaceholder: this.placeholderTextValue,
            maxValuesShown: 50,
            maxValuesMessage: '{number} skills selected',
        };
    }

    addLinkOption(searchValue) {
        const createUrl = this.addLinkValue;
        const addLinkLabel = this.addLinkLabelValue.replace("{searchValue}", searchValue);
        return [{
            text: addLinkLabel,
            value: createUrl,
            class: 'ss-remove-hover',
            html: `<a href="${createUrl}" class="create-skill-link d-flex align-items-center gap-2 text-decoration-none text-primary fw-medium px-2 py-1 rounded">
                                        <img src="/assets/plus-lg.svg" alt="Plus icon"/>
                                        <span>${addLinkLabel}</span>
                                   </a>`
        }];
    }

    highlightVisibleOption(index = 0) {
        clearTimeout(this.highlightTimeout);

        this.highlightTimeout = setTimeout(() => {
            const options = this.visibleOptions
            if (!options.length) return;

            document.querySelectorAll('.ss-option.ss-highlighted')
                .forEach(el => el.classList.remove('ss-highlighted'));

            const targetIndex = Math.min(index, options.length - 1);
            options[targetIndex].classList.add('ss-highlighted');
        }, 100); // Debounce the highlight to prevent rapid navigation from glitching or prematurely highlighting the first item.
    }

    configureOptionRefresh(){
        if (this.hasRefreshButtonTarget) {
            // saving the currently selected options inside the frame so they don't get lost when the frame is refreshed
            const frame = document.getElementById(this.refreshButtonTarget.dataset.turboFrame);
            if (frame.dataset.selectedSkills) {
                const selected = JSON.parse(frame.dataset.selectedSkills);

                this.slim.setSelected(selected);
                delete frame.dataset.selectedSkills;
            }
            document.addEventListener("visibilitychange", () => {
                frame.dataset.selectedSkills = JSON.stringify(this.slim.getSelected());
                frame.src = this.refreshButtonTarget.href;
            }, {once: true})
        }
    }

    navigateIfSelectedOptionIsALink(option){
        if (option?.html?.startsWith('<a')) {
            this.slim.search('');
            if (this.addLinkValue && option?.html?.includes(this.addLinkValue)) {
                window.open(option.value, '_blank');
            } else {
                Turbo.visit(option.value);
            }
            return false;
        }
        return true
    }

    navigateOnChange(event) {
        window.location.href = event.target.value;
    }
}