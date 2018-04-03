import ApplicationSerializer from './application';
import DS from 'ember-data';


export default ApplicationSerializer.extend({
  attrs: {
    updatedAt: { serialize: false },
    createdAt: { serialize: false },
    picture: { serialize: false },
    myCompany: { serialize: false }
  },
});
