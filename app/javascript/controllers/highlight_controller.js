import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const params = new URL(window.location.href).searchParams;
        const divId = params.get("section_id");
        const query = params.get("q");

        if (!divId || !query) return;

        const element = document.getElementById(divId);
        if (!element) return;

        const regex = new RegExp(`(${query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, "gi");
        const replacement = '<mark class="marked-text p-1 rounded text-bg-primary">$1</mark>';

        if (params.has("rating")) {
            element.querySelectorAll('[data-controller="people-skills"]').forEach(skill => {
                skill.innerHTML = skill.innerHTML.replace(regex, replacement);
            });
        } else {
            element.innerHTML = element.innerHTML.replace(regex, replacement);
        }

        const mark = element.querySelector("mark.marked-text");
        if (!mark) return;

        window.scrollTo({
            top: element.getBoundingClientRect().top + window.scrollY - 200,
            behavior: "smooth"
        });

        setTimeout(() => {
            if (!this.isElementInViewport(mark)) {
                mark.scrollIntoView(false);
            }
        }, 500);
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