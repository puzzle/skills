import "@hotwired/turbo-rails"
import "./controllers"
import "@puzzleitc/puzzle-shell";
import "@puzzleitc/puzzle-shell/style.css";

let toggleEditModeButton = document.querySelectorAll('.edit-button');
let saveButton = document.querySelectorAll('.save-button');
let cancelButton = document.querySelectorAll('.cancel-button');

document.addEventListener('turbo:load', () => {
    toggleEditModeButton.forEach((img, index) => {
        img.addEventListener("click", () => {
           let row = document.getElementById('table-row-' + index);
           row.contentEditable = "true";
           row.focus();
           toggleActionButtonDisplay(index, "block");
           img.style.display = "none";
        });
    });

    cancelButton.forEach((cancel, index) => {
        cancel.addEventListener("click", () => {
            let row = document.getElementById("table-row-" + index);
            row.contentEditable = "false";
            toggleActionButtonDisplay(index, "none");
            document.getElementById("edit-button-" + index).style.display = "block";
        });
        toggleActionButtonDisplay(index, "none");
    });
});

function toggleActionButtonDisplay(id, display) {
    document.getElementById("cancel-button-" + id).style.display = display;
    document.getElementById("save-button-" + id).style.display = display;
}