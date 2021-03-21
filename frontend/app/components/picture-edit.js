import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import PromiseProxyMixin from "@ember/object/promise-proxy-mixin";
import ObjectProxy from "@ember/object/proxy";
import Component from "@ember/component";

@classic
class ObjectPromiseProxy extends ObjectProxy.extend(PromiseProxyMixin) {}

@classic
export default class PictureEdit extends Component {
  @service ajax;

  uploadImage(file) {
    let formData = new FormData();

    if (!/\.(?:jpe?g|png|gif|svg|bmp)$/i.test(file.name)) {
      this.notify.alert("Invalider Datentyp");
      return;
    }

    if (file.size > 10000000) {
      //10MB
      this.notify.alert("Datei ist zu gross, max 10MB");
      return;
    }

    formData.append("picture", file);

    let res = this.ajax.put(this.uploadPath, {
      contentType: false,
      processData: false,
      timeout: 5000,
      data: formData
    });

    let oldPicture = this.picturePath;
    this.set("picturePath", URL.createObjectURL(file));

    res
      .then(res =>
        this.set("picturePath", `${res.data.picture_path}?${Date.now()}`)
      )
      .then(() => this.notify.success("Profilbild wurde aktualisiert!"))
      .catch(err => {
        this.notify.error(err.message);
        this.set("picturePath", oldPicture);
      });

    this.set("response", ObjectPromiseProxy.create({ promise: res }));
  }

  didInsertElement() {
    this.$(".img-input").on("change", e => {
      if (e.target.files.length) {
        this.uploadImage(e.target.files[0]);
        e.target.value = null;
      }
    });
  }

  @action
  changePicture() {
    this.$(".img-input").click();
  }
}
