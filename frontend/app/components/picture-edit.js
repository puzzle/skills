import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";

@classic
export default class PictureEdit extends Component {
  @service notify;
  @tracked picturePath = "";
  constructor() {
    super(...arguments);
    this.picturePath = this.args.imagePath;
  }
  @action
  uploadImage(e) {
    let file = e.target.files[0];
    if (!/\.(?:jpe?g|png|gif|svg|bmp)$/i.test(file.name)) {
      this.notify.alert("Invalider Datentyp");
      return;
    }

    if (file.size > 10000000) {
      //10MB
      this.notify.alert("Datei ist zu gross, max 10MB");
      return;
    }
    this.picturePath = URL.createObjectURL(file);
    this.args.person.picturePath = URL.createObjectURL(file);
  }

  @action
  changePicture() {
    document.getElementById("img-input").click();
  }
}
