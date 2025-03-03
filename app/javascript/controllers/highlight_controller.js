import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        const params = new URL(window.location.href).searchParams;
        if(params.has("q")) {
            window.find(params.get("q"))
        }
    }
}
