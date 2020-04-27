import classic from "ember-classic-decorator";
import Component from "@ember/component";
import $ from "jquery";
import { later } from "@ember/runloop";

@classic
export default class PersonJumpTo extends Component {
  didRender() {
    later(() => personJumpTo(this.query), 550);
  }
}

function personJumpTo(query) {
  const elements = $(".cv-search-searchable");
  const regex = new RegExp(query, "ig");

  searchElements(elements, regex);
}

function searchElements(elements, regex) {
  for (const element of elements) {
    if (element.textContent.search(regex) !== -1) {
      mark(element, regex);
      jumpToMarked();
      return;
    }
  }
}

function mark(element, regex) {
  const text = element.textContent;
  const textToMark = text.match(regex)[0];
  $(element).html(text.replace(regex, '<span class="mark"></span>'));
  $(".mark").text(textToMark);
}

function jumpToMarked() {
  const topOfMarked = $(".mark").offset().top - 176;
  window.scroll({ top: topOfMarked, behavior: "smooth" });
}
