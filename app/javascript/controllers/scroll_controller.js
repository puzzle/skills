import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["listItem", "scrollItem"]
    currentSelectedIndex = 0;
    headerHeight = 180;

  connect() {
    this.scrollEvent = this.scrollEvent.bind(this);
    document.addEventListener("scroll", this.scrollEvent);
  }

  disconnect() {
    document.removeEventListener("scroll", this.scrollEvent);
  }

  scrollToElement({params}) {
    document.getElementById(params.id).scrollIntoView({
      behavior: "smooth"
    });
  }

  scrollEvent() {
    let firstVisibleIndex = -1;

    for (let i = 0; i < this.scrollItemTargets.length; i++) {
      const currentElement = this.scrollItemTargets[i];
      const rect = currentElement.getBoundingClientRect();

      if (rect.bottom >= this.headerHeight && rect.top < (window.innerHeight || document.documentElement.clientHeight)) {
        firstVisibleIndex = i;
        break;
      }
    }

    if (firstVisibleIndex !== -1 && this.currentSelectedIndex !== firstVisibleIndex) {
      this.listItemTargets[this.currentSelectedIndex].classList.remove("skills-selected");
      this.listItemTargets[firstVisibleIndex].classList.add("skills-selected");
      this.currentSelectedIndex = firstVisibleIndex;
    }
  }

  isElementInViewport(el) {
    const rect = el.getBoundingClientRect();
    return (
      rect.top >= this.headerHeight &&
      rect.left >= 0 &&
      rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
      rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
  }
}