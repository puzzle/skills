import * as Sentry from "@sentry/browser";
import { Ember } from "@sentry/integrations/esm/ember";

export function startSentry() {
  Sentry.init({
    dsn: "https://39247a01fa984bf48941ef89bf1a510b@sentry.puzzle.ch/44",
    integrations: [new Ember()]
  });
}
