import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
// Connects to data-controller="table"
export default class extends Controller {
  static targets = ["childSelect", "parentSelect"];

  adjustChildren({params}) {
      const skill = params.skill;
      let parent = event.target.selectedOptions[0].value;
      get(`/skills/${skill.id}/edit?parent=${parent}`, {
         responseKind: "turbo-stream"
      });
  }
}
