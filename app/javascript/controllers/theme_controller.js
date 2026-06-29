import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
// Cycles the colour scheme preference auto -> light -> dark, persists it in the
// `theme` cookie and applies it via the <html data-bs-theme> attribute.
const PREFS = ["auto", "light", "dark"];

export default class extends Controller {
    static targets = ["icon"];
    // The icon paths are fingerprinted asset URLs passed in from the view
    // (see app/assets/images/theme/*.svg, Bootstrap Icons, MIT). They are
    // applied as a CSS mask so the glyph inherits the toggle's `currentColor`.
    static values = {
        pref: { type: String, default: "auto" },
        autoIcon: String,
        lightIcon: String,
        darkIcon: String,
    };

    connect() {
        this.media = window.matchMedia("(prefers-color-scheme: dark)");
        this.systemListener = () => {
            if (this.prefValue === "auto") this.apply();
        };
        this.media.addEventListener("change", this.systemListener);
        this.render();
    }

    disconnect() {
        this.media.removeEventListener("change", this.systemListener);
    }

    cycle() {
        const next = (PREFS.indexOf(this.prefValue) + 1) % PREFS.length;
        this.prefValue = PREFS[next];
        document.cookie = `theme=${this.prefValue}; path=/; max-age=31536000; samesite=lax`;
        this.render();
    }

    render() {
        this.apply();
        if (!this.hasIconTarget) return;
        const url = {
            auto: this.autoIconValue,
            light: this.lightIconValue,
            dark: this.darkIconValue,
        }[this.prefValue];
        this.iconTarget.style.webkitMaskImage = `url("${url}")`;
        this.iconTarget.style.maskImage = `url("${url}")`;
    }

    apply() {
        const dark = this.prefValue === "dark" ||
            (this.prefValue === "auto" && this.media.matches);
        document.documentElement.setAttribute("data-bs-theme", dark ? "dark" : "light");
        // Notify components that read theme CSS variables at render time (e.g. the
        // chart controller) so they can restyle without a full page reload.
        this.dispatch("changed", { detail: { dark }, prefix: "theme" });
    }
}
