import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        let searchTerm = new URL(window.location.href).searchParams.get("q")?.trim();
        if (!searchTerm) return;
        const elements = this.element.querySelectorAll(".found-search-term");

        let escapedSearchTerm = searchTerm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        if (escapedSearchTerm.includes(",")) {
            escapedSearchTerm = escapedSearchTerm.split(",").map(s => s.trim()).join("|");
        }

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
}