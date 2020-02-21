import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Component from "@ember/component";

@classic
export default class ScrollToTopButton extends Component {
  @action
  scrollToTop() {
    window.scroll({ top: 0, behavior: "smooth" });
  }
}
