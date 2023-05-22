import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";

@classic
export default class PictureEdit extends Component {
  @service notify;
  @service intl;
  @tracked picturePath = "";
  constructor() {
    super(...arguments);
    this.picturePath = this.args.imagePath;
  }
  @action
  uploadImage(e) {
    let file = e.target.files[0];
    if (!/\.(?:jpe?g|png|gif|svg|bmp)$/i.test(file.name)) {
      this.notify.alert(this.intl.t("image.invalid-datatype"));
      return;
    }

    if (file.size > 10000000) {
      //10MB
      this.notify.alert(this.intl.t("image.file-too-large"));
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
