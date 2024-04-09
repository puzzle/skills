import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  connect() {}

  filterNames(event) {
    const searchText = event.target.value.trim().toLowerCase();
    const options = this.element.querySelectorAll(".form-select option");
    const errorText = document.getElementById("error-text");
    options.forEach(option => {
        const optionText = option.textContent.toLowerCase();
        const moreOrEqualTo2 = searchText.length >= 2;
        const lessOrEqualTo1 = searchText.length <= 1

        option.style.display = (optionText.includes(searchText) && moreOrEqualTo2) || lessOrEqualTo1 ? "block" : "none";
    });
    errorText.style.display = searchText.length < 2 && searchText ? "block" : "none";
  }

  handleChange(event) {
      window.location.href = event.target.dataset.value + event.target.value;
  }
}
