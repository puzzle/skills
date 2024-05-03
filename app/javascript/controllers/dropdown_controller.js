import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {

  connect() {
    const element = document.getElementById('dropdown');
    console.log(element)
    let select =  new SlimSelect({
          select: element
    });
  }

  disconnect() {
    window.addEventListener("popstate", () => {
      window.location.reload();
    });
  }

  handleChange(event) {
      window.location.href = event.target.dataset.value + event.target.value;
  }
}
