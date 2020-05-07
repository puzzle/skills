import classic from "ember-classic-decorator";
import Component from "@ember/component";
import $ from "jquery";
import { later, scheduleOnce } from "@ember/runloop";

@classic
export default class PersonJumpTo extends Component {
  didRender() {
    personJumpTo(this);
  }
}

const MAX_TIMEOUT = 2000;
const TIME_STEPS = 100;
let timeout = 0;

function personJumpTo(context) {
  if (context.query) {
    later(() => {
      timeout += TIME_STEPS;

      if (timeout < MAX_TIMEOUT) {
        //Invoke DOM manipulation after render phase (later schedules for action phase)
        scheduleOnce("afterRender", context, jumpOrRetry(context));
      }
    }, TIME_STEPS);
  }
}

function jumpOrRetry(context) {
  if (!couldJumpTo(context.query)) {
    personJumpTo(context);
  }
}

function couldJumpTo(query) {
  const elements = $(".cv-search-searchable");
  const regex = new RegExp(query, "ig");

  return matchFound(elements, regex);
}

function matchFound(elements, regex) {
  for (const element of elements) {
    if (element.textContent.search(regex) !== -1) {
      mark(element, regex);
      jumpToMarked();
      return true;
    }
  }
  return false;
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
