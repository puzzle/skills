import {Controller} from "@hotwired/stimulus"
import {Modal} from "bootstrap"

export default class extends Controller {
    connect() {
        if (location.href.includes("?open_modal=true")){
            this.element.addEventListener('hidden.bs.modal', () => {
                history.replaceState({}, '', location.href.replace("?open_modal=true", ""))
                document.getElementById("remote_modal").remove()
            }, {once: true})
        }

        this.modal = Modal.getOrCreateInstance(this.element)
        this.modal.show()

        this.beforeCache = this.beforeCache.bind(this)
        document.addEventListener("turbo:before-cache", this.beforeCache)
    }

    disconnect() {
        document.removeEventListener("turbo:before-cache", this.beforeCache)
        if (this.modal) this.modal.dispose()
        this.removeModalLeftovers()
    }

    beforeCache() {
        if (this.modal) this.modal.dispose()

        this.removeModalLeftovers()
    }

    removeModalLeftovers() {
        // Remove bootstrap modal leftovers
        document.body.classList.remove("modal-open")
        document.body.style.removeProperty("overflow")
        document.body.style.removeProperty("padding-right")
    }
}