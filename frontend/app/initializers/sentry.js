import * as Sentry from "@sentry/browser";
import { Ember } from "@sentry/integrations/esm";
import ENV from "../config/environment";

export function initialize(application) {
  if (ENV.environment === "production") {
    Sentry.init({
      dsn: ENV.sentryDsn,
      integrations: [new Ember()]
    });
  }
}

export default {
  initialize
};
