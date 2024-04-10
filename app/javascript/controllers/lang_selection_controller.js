import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lang-selection"
export default class extends Controller {
  connect() {
    this.setOptionState();
  }
  setOptionState() {
    const languageSelects= document.getElementsByClassName("language-select");
    const selectedLanguages = getSelectedLanguages();
    for(const languageSelect of languageSelects) {
      for(const option of languageSelect.options) {
        //Deactivate option if it is not the current option of the dropdown but is selected in another dropdown
        option.disabled = (selectedLanguages.includes(option.value)) && (languageSelect.selectedOptions[0].value !== option.value);
      }
    }
  }

  setNewLangOption() {
    const selectedLanguages = getSelectedLanguages();
    const language_selects = Array.from(document.getElementsByClassName("language-select"));
    const language_select = language_selects[language_selects.length - 1]
    //Remove newly added language since we dont want to skip that
    selectedLanguages.pop();
    while(selectedLanguages.includes(language_select.selectedOptions[0].value)) {
      language_select.selectedIndex++;
    }
    this.setOptionState();
  }
}

function getSelectedLanguages() {
  let selectedLanguages  = [];

  const languageSelects= document.getElementsByClassName("language-select");
  for(const languageSelect of languageSelects) {
      if(!["1", "true"].includes(languageSelect.closest(".nested-fields").querySelector('input[type="hidden"]').value)) {
        selectedLanguages.push(languageSelect.selectedOptions[0].value)
      }
  }
  return selectedLanguages;
}