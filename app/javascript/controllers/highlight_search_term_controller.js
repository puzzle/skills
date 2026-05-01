import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const searchTerm = new URL(window.location.href).searchParams.get("q")?.trim();

        if (!searchTerm) return;
        const elements = document.querySelectorAll(".bg-skills-search-result-blue.text-decoration-none.text-white.ps-1.p-2.rounded-1.text-center.mb-0");

        const escapedSearchTerm = searchTerm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        const regex = new RegExp(`(${escapedSearchTerm})`, "gi");

        elements.forEach((element) => {
            const text = element.textContent.trim();

            if (text.toLowerCase() === searchTerm.toLowerCase()) return;

            const highlightedText = text.replace(regex, '<mark class="p-1 rounded bg-skills-green text-white">$1</mark>');

            if (highlightedText !== text) {
                element.innerHTML = highlightedText;
            }
        });
    }
}