import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    clearAndSubmit(event) {
        document.querySelectorAll('[name^="operator["]').forEach(el => {
            el.value = ''
        })
        this.element.requestSubmit()
    }
}