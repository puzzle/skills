import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["results"];

  connect() {
    document.addEventListener('click', (event)=> {
      const outsideClick = !this.element.contains(event.target);
      this.resultsTarget.style.display = outsideClick ? "none" : "block";
    });
  }
}
