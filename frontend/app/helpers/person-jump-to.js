import { helper } from "@ember/component/helper";
import $ from "jquery";
import { later } from "@ember/runloop";

export function personJumpTo([query, foundIn]) {
  later(() => markAndJump(query), 550);
}

function markAndJump(query) {
  const elements = $(".cv-search-searchable");
  const regex = new RegExp(query, "ig");
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
  const markedText = text.match(regex)[0];
  $(element).html(text.replace(regex, '<span class="mark"></span>'));
  $(".mark").text(markedText);
}

function jumpToMarked() {
  const topOfMarked = $(".mark").offset().top - 176;
  window.scroll({ top: topOfMarked, behavior: "smooth" });
}

export default helper(personJumpTo);
