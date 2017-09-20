import { Model, hasMany } from 'ember-cli-mirage';

export default Model.extend({
  projects: hasMany({ inverse: 'person' }),
  advancedTrainings: hasMany({ inverse: 'person' }),
  educations: hasMany({ inverse: 'person' }),
  activities: hasMany({ inverse: 'person' })
});
