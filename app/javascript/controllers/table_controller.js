import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="table"
export default class extends Controller {
  static targets = ["childSelect", "parentSelect"];

  adjustChildren() {
    fetch('api/categories/' + this.parentSelectTarget.value)
        .then(response => {
          if (!response.ok) {
            throw new Error('Network response was not ok');
          }
          return response.json();
        })
        .then(response => {
            //Clear select field
            let length = this.childSelectTarget.options.length;
            for(let i = length-1; i >= 0; i--) {
                this.childSelectTarget.options[i] = null;
            }

            //Add new Options
            const categoryArray = response.included;
            for(let category of categoryArray) {
                let opt = document.createElement("option");
                opt.value = category.attributes.id;
                opt.textContent = category.attributes.title;
                this.childSelectTarget.append(opt);
            }
        })
        .catch(error => {
          console.error('Fetch error:', error);
        });
  }
}
