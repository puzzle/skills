import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="instant-click"
export default class extends Controller {
  connect() {
    this.element.click();
  }
}
