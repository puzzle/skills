import classic from "ember-classic-decorator";
import Service, { inject as service } from "@ember/service";

@classic
export default class DownloadService extends Service {
  @service("keycloak-session")
  session;

  file(url) {
    let xhr = new XMLHttpRequest();
    xhr.responseType = "blob";
    xhr.onload = () => {
      let [, fileName] = /filename\*=UTF-8''(.*?)$/.exec(
        xhr.getResponseHeader("Content-Disposition")
      );
      let file = new File([xhr.response], decodeURIComponent(fileName));
      let link = document.createElement("a");
      link.style.display = "none";
      link.href = URL.createObjectURL(file);
      link.download = file.name;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    };
    xhr.open("GET", url);
    xhr.setRequestHeader(
      "Authorization",
      "Bearer " + this.get("session.token")
    );
    xhr.send();
  }
}
