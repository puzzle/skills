import ApplicationSerializer from './application';

export default ApplicationSerializer.extend({
  attrs: {
    updatedAt: { serialize: false },
    createdAt: { serialize: false },
    picture: { serialize: false },
    myCompany: { serialize: false }
  },
});
