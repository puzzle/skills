
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    changeImage() {
        const avatarUploader = document.getElementById("avatar-uploader");
        const avatar = document.getElementById("avatar");
        avatar.src = URL.createObjectURL(avatarUploader.files[0])
    }
}