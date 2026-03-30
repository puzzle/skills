import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const params = new URL(window.location.href).searchParams;
        const divId = params.get("person_relations");
        const query = params.get("q");

        if (!divId || !query) return;

        const element = document.getElementById(divId);

        if (element) {
            const escapedQuery = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

            const originalHTML = element.innerHTML;
            const regex = new RegExp(`(${escapedQuery})`, "gi");

            element.innerHTML = originalHTML.replace(
                regex,
                '<mark class="p-1 rounded" style="background-color: #3297fd; color: white;">$1</mark>'
            );
            const headerOffset = 200;
            const elementPosition = element.getBoundingClientRect().top;

            const offsetPosition = elementPosition + window.scrollY - headerOffset;

            window.scrollTo({
                top: offsetPosition,
                behavior: "smooth"
            });
        }
    }
}