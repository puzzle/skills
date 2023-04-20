import { run } from "@ember/runloop";
import { unsetContext } from "@ember/test-helpers";

export default function destroyApp(application) {
  unsetContext();
  run(application, "destroy");
  if (window.server) {
    window.server.shutdown();
  }
}
