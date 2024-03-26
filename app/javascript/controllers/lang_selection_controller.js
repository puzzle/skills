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
      if(!["1", "true"].includes(languageSelect.closest(".nested-fields").querySelector('input[type="hidden"]').value)) {
        selectedLanguages.push(languageSelect.selectedOptions[0].value)
      }
    }

    for(const languageSelect of languageSelects) {
      for(const option of languageSelect.options) {
        //Deactivate option if it is not the current option of the dropdown and not the default option, but is selected in another dropdown
        option.disabled = (selectedLanguages.includes(option.value)) && (languageSelect.selectedOptions[0].value !== option.value) && (option.value !== '-')
      }
    }
  }
}
