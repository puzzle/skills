import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
    connect() {
        this.modal = new Modal(this.element)
        this.modal.show()

        this.beforeCache = this.beforeCache.bind(this)
        document.addEventListener("turbo:before-cache", this.beforeCache)
    }

    disconnect() {
        document.removeEventListener("turbo:before-cache", this.beforeCache)
        if (this.modal) this.modal.dispose()
    }

    beforeCache() {
        if (this.modal) this.modal.dispose()

        // Remove bootstrap modal leftovers
        document.body.classList.remove("modal-open")
        document.body.style.removeProperty("overflow")
        document.body.style.removeProperty("padding-right")
    }
}