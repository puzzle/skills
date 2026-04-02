import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    changeImage(event) {
        const avatar = document.getElementById("avatar");

        if (event.target.files) {
            const avatarUrl =  URL.createObjectURL(event.target.files[0])
            document.getElementById("avatar-url").value = ""
            avatar.src = avatarUrl
        } else {
            avatar.src = event.target.value
        }
    }
}