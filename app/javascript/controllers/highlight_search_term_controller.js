import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        let searchTerm = new URL(window.location.href).searchParams.get("q")?.trim();
        if (!searchTerm) return;
        const elements = this.element.querySelectorAll(".found-search-term");

        let escapedSearchTerm = searchTerm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

        escapedSearchTerm = this.buildSearchPattern(escapedSearchTerm);
        const regex = new RegExp(`(${escapedSearchTerm})`, "gi");

        elements.forEach((element) => {
            const userValue = element.textContent.trim();

            if (userValue.toLowerCase() === searchTerm.toLowerCase()) return;

            const highlightedText = userValue.replace(regex, '<mark class="p-1 rounded bg-skills-green text-white">$1</mark>');

            if (highlightedText !== userValue) {
                element.innerHTML = highlightedText;
            }
        });
    }

    buildSearchPattern(term) {
        if (!term.includes(",")) return term;

        return term.split(",")
            .map(s => s.trim())
            .filter(Boolean)
            .join("|");
    }
}