import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  selectLang(e) {
    const langButton = e.currentTarget;
    for(const element of document.querySelectorAll("[lang-box]")) {
      if(element.getAttribute("lang-box") === langButton.getAttribute("lang-button")) {
        element.style.display = "block";
      } else {
        element.style.display = "none"
      }
    }
  }

  changeLang(e) {
    const langSelector = e.currentTarget;
    const langBoxIndex = langSelector.parentElement.parentElement.getAttribute("lang-box");
    document.querySelector(`[lang-button="${langBoxIndex}"]`).children[0].textContent = langSelector.selectedOptions[0].value;
  }
}
