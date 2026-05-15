import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    get urlParams() {
        return new URL(window.location.href).searchParams;
    }

    get #searchTerm() {
        return this.urlParams.get("q")?.trim();
    }

    get searchRegex() {
        if (!this.#searchTerm) return null;

        let escapedTerm = this.#searchTerm.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

        if (escapedTerm.includes(",")) {
            escapedTerm = escapedTerm.split(",")
                .map(s => s.trim())
                .filter(Boolean)
                .join("|");
        }

        return new RegExp(`(${escapedTerm})`, "gi");
    }
}