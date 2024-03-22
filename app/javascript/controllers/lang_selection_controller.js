import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lang-selection"
export default class extends Controller {
  connect() {
    this.setOptionState();
  }
  setOptionState() {
    let selectedLanguages = [];

    const languageSelects =  document.getElementsByClassName("language-select");
    for(const languageSelect of languageSelects) {
      selectedLanguages.push(languageSelect.selectedOptions[0].value)
    }

    for(const languageSelect of languageSelects) {
      for(const option of languageSelect.options) {
        option.disabled = selectedLanguages.includes(option.value)
      }
    }
  }
}
