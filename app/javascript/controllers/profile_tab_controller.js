import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['tab', 'cv', 'skills']

    connect() {
        this.element.addEventListener("click", this.switchTab.bind(this))
    }

    switchTab(event) {
        if(event.target.className === 'nav-link') {
            this.tabTargets.forEach((element) => element.classList.remove('active'))
            event.target.classList.add('active');
        }
    }

    switchToCv() {
        this.switchDisplay(this.skillsTarget, this.cvTarget);
    }

    switchToSkills() {
        this.switchDisplay(this.cvTarget, this.skillsTarget);
    }

    switchDisplay(elementToHide, elementToShow) {
        elementToHide.style.display = "none";
        elementToShow.style.display = "block";
    }

}