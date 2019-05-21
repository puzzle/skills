import EmberRouter from "@ember/routing/router";
import config from "./config/environment";

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route("people", function() {
    this.route("new");
    this.route(
      "person",
      { path: "/:person_id", resetNamespace: true },
      function() {
        this.route("fws");
        this.route("skills");
      }
    );
  });
  this.route("login");
  this.route("companies", function() {
    this.route("show", { path: "/:company_id" });
    this.route("new");
  });
  this.route("skills", function() {});
  this.route("cv_search");
});

export default Router;
