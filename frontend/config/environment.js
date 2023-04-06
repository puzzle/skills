/* eslint-env node */
"use strict";

module.exports = function(environment) {
  let ENV = {
    modulePrefix: "frontend",
    environment,
    rootURL: "/",
    sentryDsn: "",
    locationType: "auto",
    helplink: "",
    keycloak: {
      disable: "",
      url: "",
      realm: "",
      clientId: "",
      secret: ""
    },

    EmberENV: {
      FEATURES: {
        "ds-extended-errors": true
      },
      EXTEND_PROTOTYPES: {
        // Prevent Ember Data from overriding Date.parse.
        Date: false
      }
    },

    APP: {
      documentExportHost: ""
    },

    "ember-validated-form": {
      theme: "bootstrap"
    },
    "ember-form-for": {
      errorsPath: "error.PROPERTY_NAME.validation"
    },
    moment: {
      includeLocales: ["de"]
    }
  };

  if (environment === "development") {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
    ENV.APP.documentExportHost = "http://localhost:3000";
  }

  if (environment === "test") {
    // Testem prefers this...
    ENV.locationType = "none";

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    // ENV.APP.rootElement = "#ember-testing";
    ENV.APP.documentExportHost =
      "http://localhost:" + (process.env.RAILS_PORT || "3000");
  }

  if (environment === "production") {
    ENV.sentryDsn = process.env.SENTRY_DSN_FRONTEND;
  }
  return ENV;
};
