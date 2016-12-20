import { Model, hasMany, belongsTo } from 'ember-cli-mirage';

export default Model.extend({
  activities: hasMany('activity'),
  advancedTrainings: hasMany('advanced-training'),
  competences: hasMany('competence'),
  educations: hasMany('education'),
  projects: hasMany('project'),
  "status": belongsTo('status')
});
