import ApplicationSerializer from './application';

export default ApplicationSerializer.extend({
  include: ['competences', 'projects', 'activities', 'educations', 'advanced_trainings']
});
