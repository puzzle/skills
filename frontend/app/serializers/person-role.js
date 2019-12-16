import ApplicationSerializer from "./application";

export default ApplicationSerializer.extend({
  attrs: {
    level: { serialize: false }
  }
});
