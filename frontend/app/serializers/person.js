import ApplicationSerializer from "./application";

export default ApplicationSerializer.extend({
  attrs: {
    picturePath: { serialize: false },
    updatedAt: { serialize: false }
  }
});
