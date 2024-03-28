import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['tab']

    connect() {
        this.element.addEventListener("click", this.switchTab.bind(this));
    }

    switchTab(event) {
        if(event.target.className === 'nav-link') {
            this.tabTargets.forEach((element) => element.classList.remove('active'))
            event.target.classList.add('active');
        }
    }
}