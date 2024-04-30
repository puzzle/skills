import {Controller} from "@hotwired/stimulus"

export default class extends Controller {

    connect() {
        console.log("Connected with scroll")
    }

    scrollToElement({params}) {
        let element = document.getElementById(params.id);
        element.scrollIntoView();
    }
}