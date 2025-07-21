import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["reference"]

    openReference(event) {
        event.preventDefault()
        event.stopPropagation()

        const text = this.referenceTarget?.textContent?.trim()

        if (text) {
            window.open(text)
        }
    }
}
