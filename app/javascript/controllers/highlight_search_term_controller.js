import Base_highlight_controller from "./base_highlight_controller";

export default class extends Base_highlight_controller {
    connect() {
        const regex = this.searchTermRegex;

        if (!regex) return;

        const elements = this.element.querySelectorAll(".found-search-term");

        elements.forEach((element) => {
            this.#highlightElementText(element, regex);
        });
    }

    #highlightElementText(element, regex) {
        const userValue = element.textContent.trim();

        const replacement = '<mark class="highlight-search-term">$&</mark>';
        const highlightedText = userValue.replace(regex, replacement);

        if (highlightedText !== userValue) {
            element.innerHTML = highlightedText;
        }
    }
}