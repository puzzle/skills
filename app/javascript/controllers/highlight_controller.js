import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const params = new URL(window.location.href).searchParams;
        const divId = params.get("section_id");
        const query = params.get("q");

        if (!divId || !query) return;

        const element = document.getElementById(divId);
        const allSkills = element.querySelectorAll('[data-controller="people-skills"]');

        if (element) {
            const escapedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
            const regex = new RegExp(`(${escapedQuery})`, "gi");

            allSkills.forEach((skill) => {
                const originalHTML = skill.innerHTML;
                skill.innerHTML = originalHTML.replace(
                    regex,
                    '<mark id="marked-text"  class="p-1 rounded text-bg-primary">$1</mark>'
                );
            });

            const headerOffset = 200;

            const mark = document.getElementById("marked-text");

            const elementPosition = element.getBoundingClientRect().top;
            const offsetPosition = elementPosition + window.scrollY - headerOffset;


            window.scrollTo({
                top: offsetPosition,
                behavior: "smooth"
            });

            setTimeout(() => {
                if (!this.isElementInViewport(mark)) {
                    mark.scrollIntoView(false)
                }
            }, 500)
        }
    }

    isElementInViewport(element) {
        const rect = element.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }

}