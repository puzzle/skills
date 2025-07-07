import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["list", "listItem", "scrollItem", "parent"]
    currentSelectedIndex = -1;
    offsetY = 0;

    connect() {
        document.removeEventListener('scroll', () => {});
        ['turbo:frame-load', 'turbo:load'].forEach(e => {
            window.addEventListener(e, () => {
                this.offsetY = this.parentTarget.getBoundingClientRect().top + window.scrollY;
                // this.listTarget.style.top = `${this.offsetY}px`;
                document.addEventListener("scroll", () => {
                    this.highlight();
                });
                this.highlight()
            })
        })
    }

    disconnect() {
        document.removeEventListener("scroll", () => {
            this.highlight();
        });
    }

    scrollToElement({ params }) {
        const elem = document.getElementById(params.id);
        const y = elem.getBoundingClientRect().top - this.offsetY + window.scrollY;
        window.scrollTo({ top: y, behavior: 'smooth' });
    }

    highlight() {
        for (const [i, scrollItem] of this.scrollItemTargets.entries()) {
            if (this.isElementInViewport(scrollItem)) {
                this.listItemTargets.forEach(e => e.classList.remove("skills-selected"))
                this.listItemTargets[i].classList.add("skills-selected");
                this.currentSelectedIndex = i;
                break;
            }
        }
    }

    isElementInViewport(el) {
        let rect = el.getBoundingClientRect();
        return rect.bottom > this.offsetY;
    }
}