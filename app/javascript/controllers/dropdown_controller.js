import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown-links"
export default class extends Controller {
  connect() {}

  filterOptions(event) {
    const searchText = event.target.value.toLowerCase();
    const options = this.element.querySelectorAll(".form-select option");
    options.forEach(option => {
      const optionText = option.textContent.toLowerCase();
      if (optionText.includes(searchText)) {
        option.style.display = "block";
      } else if (searchText.length < 2) {
        // shows everything
      } else {
        option.style.display = "none";
      }
    });
  }

  handleChange(event) {
      window.location.href = event.target.dataset.value + event.target.value;
  }
}
