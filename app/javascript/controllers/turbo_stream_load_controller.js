import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const turboStreamLoadEvent = new CustomEvent('turbo-stream-load');
        window.dispatchEvent(turboStreamLoadEvent);
    }
}