import ApplicationSerializer from "./application";

export default ApplicationSerializer.extend({
  attrs: {
    createdAt: { serialize: false },
    updatedAt: { serialize: false },
    companyType: { serialize: false }
  }
});
