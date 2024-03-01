class addFields {
    constructor() {
        this.links = document.querySelectorAll(".add_fields");
        this.iterateLinks();
    }

    iterateLinks() {
        // If there are no links on the page, stop the function from executing.
        if (this.links.length === 0) return;
        // Loop over each link on the page. A page could have multiple nested forms.
        this.links.forEach((link) => {
            link.addEventListener("click", (e) => {
                this.handleClick(link, e);
            });
        });
    }

    handleClick(link, e) {
        // Stop the function from executing if a link or event were not passed into the function.
        if (!link || !e) return;
        // Prevent the browser from following the URL.
        e.preventDefault();
        // Save a unique timestamp to ensure the key of the associated array is unique.
        let time = new Date().getTime();
        // Save the data id attribute into a variable. This corresponds to `new_object.object_id`.
        let linkId = link.dataset.id;
        // Create a new regular expression needed to find any instance of the `new_object.object_id` used in the fields data attribute if there's a value in `linkId`.
        let regexp = linkId ? new RegExp(linkId, "g") : null;
        // Replace all instances of the `new_object.object_id` with `time`, and save markup into a variable if there's a value in `regexp`.
        let newFields = regexp ? link.dataset.fields.replace(regexp, time) : null;
        // Add the new markup to the form if there are fields to add.
        newFields ? link.insertAdjacentHTML("beforebegin", newFields) : null;
    }
}
window.addEventListener("turbo:frame-render", () => new addFields());