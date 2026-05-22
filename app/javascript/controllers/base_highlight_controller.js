import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    get urlParams() {
        return new URL(window.location.href).searchParams;
    }

    get searchTerm() {
        return this.urlParams.get("q")?.trim();
    }

    escapeForRegex(term) {
        return term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }

    get searchTermRegex() {
        if (!this.searchTerm) return null;

        let escapedTerm = this.escapeForRegex(this.searchTerm);

        if (escapedTerm.includes(",")) {
            escapedTerm = escapedTerm.split(",")
                .map(s => s.trim())
                .filter(Boolean)
                .join("|");
        }

        return new RegExp(`(${escapedTerm})`, "gi");
    }

    get attributeRegex() {
        return new RegExp(`(${this.escapeForRegex(this.searchTerm)})`, "gi");
    }
}