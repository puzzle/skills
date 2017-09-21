import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';
import DS from 'ember-data';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';
import { UnauthorizedError, ForbiddenError } from 'ember-ajax/errors';

export default Route.extend(ApplicationRouteMixin, {
  session: service('session'),

  isAuthError(error) {
    return error instanceof UnauthorizedError || error instanceof ForbiddenError ||
      error instanceof DS.UnauthorizedError || error instanceof DS.ForbiddenError;
  },

  actions: {
    error(error, transition) {
      if (this.isAuthError(error)) {
        this.get('session').invalidate();
      }
    },
    invalidateSession() {
      this.get('session').invalidate();
    }
  }
});
