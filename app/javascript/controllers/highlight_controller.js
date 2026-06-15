import Base_highlight_controller from "./base_highlight_controller";

export default class extends Base_highlight_controller {
    connect() {
        const divId = this.urlParams.get("section_id");
        if (!divId || !this.searchTerm) return;

        const containerElement = document.getElementById(divId);
        if (!containerElement) return;

        const markElement = this.#highlightText(containerElement);

        if (markElement) {
            this.#smoothScrollTo(containerElement);
            this.#ensureVisibility(markElement);
        }
    }

    #highlightText(element) {
        const originalHTML = element.innerHTML;

        const regex = new RegExp(`(${this.escapeForRegex(this.searchTerm)})(?![^<]*>)`, 'gi');

        element.innerHTML = originalHTML.replace(
            regex,
            '<mark class="highlight">$1</mark>'
        );

        return element.querySelector("mark.highlight");
    }

    #smoothScrollTo(element) {
        window.scrollTo({
            top: element.getBoundingClientRect().top + window.scrollY - 200,
            behavior: "smooth"
        });
    }

    #ensureVisibility(markElement) {
        setTimeout(() => {
            if (!this.#isElementInViewport(markElement)) {
                markElement.scrollIntoView(false);
            }
        }, 500);
    }

    #isElementInViewport(element) {
        const rect = element.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }
}