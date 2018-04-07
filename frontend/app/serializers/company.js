import ApplicationSerializer from './application';
import DS from 'ember-data';


export default ApplicationSerializer.extend({
  attrs: {
    createdAt: { serialize: false },
    updatedAt: { serialize: false },
    myCompany: { serialize: false }
  },
});
