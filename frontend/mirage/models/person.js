import { Model, hasMany } from 'ember-cli-mirage';

export default Model.extend({
  competences: hasMany(),
  projects: hasMany(),
  advanced_trainings: hasMany(),
  educations: hasMany(),
  activities: hasMany()
});
