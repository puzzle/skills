import BaseSearchController from "./base_highlight_controller"

export default class extends BaseSearchController {
    connect() {
        const params = this.urlParams;
        const divId = params.get("section_id");
        const regex = this.searchRegex;

        if (!divId || !regex) return;

        const element = document.getElementById(divId);
        if (!element) return;

        const replacement = '<mark class="highlight">$1</mark';

        if (params.has("rating")) {
            element.querySelectorAll('[data-controller="people-skills"]').forEach(skill => {
                skill.innerHTML = skill.innerHTML.replace(regex, replacement);
            });
        } else {
            element.innerHTML = element.innerHTML.replace(regex, replacement);
        }

        const mark = element.querySelector("mark.highlight");
        if (!mark) return;

        this.scrollToMark(element, mark);
    }

    scrollToMark(element, mark) {
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