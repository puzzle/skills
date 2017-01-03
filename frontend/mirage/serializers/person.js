import ApplicationSerializer from './application';

export default ApplicationSerializer.extend({
  include: ['competences', 'projects', 'activities', 'statues', 'educations', 'advanced_trainings']
});
