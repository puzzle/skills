import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="skills-empty-space"
export default class extends Controller {
    static targets = ["container"]

    goCrazy() {
        this.containerTarget.innerHTML = "";
        let element = document.createElement("h1");
        let text = document.createTextNode("Du hesch drufdrückt");
        element.appendChild(text);

        this.containerTarget.style.display = "flex";
        this.containerTarget.style.flexDirection = "column";
        this.containerTarget.style.alignItems = "center";
        this.containerTarget.style.justifyContent = "center";
        this.containerTarget.style.height = "100vh";


        let gif = document.createElement("img");
        gif.src = "https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNW0xNXpscDY5MXJkd3YxOWdmZG12cDk1YW45cGwxeDd1ODR4bGt1YyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/tHIRLHtNwxpjIFqPdV/giphy.gif";
        this.containerTarget.appendChild(element);
        this.containerTarget.appendChild(gif);
    }


}