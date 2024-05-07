import { Controller } from "@hotwired/stimulus"
import SlimSelect from 'slim-select';

// Connects to data-controller="dropdown-links"
export default class extends Controller {

  connect() {
    new SlimSelect({
          select: '#dropdown'
    });
  }

  handleChange(event) {
      window.location.href = event.target.dataset.value + event.target.value;
  }
}
