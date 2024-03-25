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
      //Check if field was not deleted by user
      if(languageSelect.closest(".nested-fields").querySelector('input[type="hidden"]').value !== "1") {
        selectedLanguages.push(languageSelect.selectedOptions[0].value)
      }
    }

    for(const languageSelect of languageSelects) {
      for(const option of languageSelect.options) {
        //Deactivate option if it is not the current option of the dropdown but is selected in another dropdown
        option.disabled = (selectedLanguages.includes(option.value)) && (languageSelect.selectedOptions[0].value !== option.value)
      }
    }
  }
}
