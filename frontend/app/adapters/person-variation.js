import ApplicationAdapter from './application';

export default ApplicationAdapter.extend({
  pathForType(_modelName) {
    return 'people';
  }
});
