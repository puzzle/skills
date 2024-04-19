import { Controller } from "@hotwired/stimulus"

let counter = -1;
// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["results", "options"];

  connect() {
    document.addEventListener('click', (event)=> {
      const outsideClick = !this.element.contains(event.target);
      this.resultsTarget.style.display = outsideClick ? "none" : "block";
    });

    document.addEventListener("keydown", (event) => {
      const allowedKeyCodes = ["ArrowDown", "ArrowUp"];
      if(allowedKeyCodes.includes(event.code)) {
        event.preventDefault();
        if(event.code == "ArrowDown") {
          counter++;
        } else if (event.code == "ArrowUp") {
          counter--;
        }
        counter = counter >= this.optionsTargets.length ? 0 : counter;
        counter = counter < 0 ? 0 : counter;
        this.optionsTargets[counter].focus();
      }
    });
  }
}
