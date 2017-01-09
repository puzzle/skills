import { Model, hasMany } from 'ember-cli-mirage';

export default Model.extend({
  competences: hasMany(),
  projects: hasMany(),
  advancedTrainings: hasMany(),
  educations: hasMany(),
  activities: hasMany()
});
