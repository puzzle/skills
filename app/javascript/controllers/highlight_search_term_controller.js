import BaseSearchController from "./base_highlight_controller"

export default class extends BaseSearchController {
    connect() {
        const regex = this.searchRegex;

        if (!regex) return;

        const elements = this.element.querySelectorAll(".found-search-term");
        const replacement = '<mark class="highlight-search-term">$1</mark>';

        elements.forEach((element) => {
            const userValue = element.textContent.trim();
            const highlightedText = userValue.replace(regex, replacement);

            if (highlightedText !== userValue) {
                element.innerHTML = highlightedText;
            }
        });
    }
}