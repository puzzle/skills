import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["listItem", "scrollItem"]
    currentSelectedIndex = 0;

    scrollToElement({params}) {
        document.getElementById(params.id).scrollIntoView();
    }

    scrollEvent() {
        for(let i = 0; i < this.scrollItemTargets.length; i++) {
            if(this.isElementInViewport(this.scrollItemTargets[i])) {
                if(this.currentSelectedIndex !== i) {
                    this.listItemTargets[i].classList.add("skills-selected");
                    this.listItemTargets[this.currentSelectedIndex].classList.remove("skills-selected");
                    this.currentSelectedIndex = i;
                }
                break;
            }
        }
    }

    isElementInViewport(el) {
        let rect = el.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }
}