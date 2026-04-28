import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    changeImage(event) {
        const avatar = document.getElementById("avatar");

        if (event.target.files) {
            const avatarUrl = URL.createObjectURL(event.target.files[0])
            document.getElementById("person_picture_url").value = ""
            avatar.src = avatarUrl
        }
    }
}