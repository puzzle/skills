import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const params = new URLSearchParams(window.location.search);
        if(params.has("q")) {
            window.find(params.get("q"))
        }
    }
}
