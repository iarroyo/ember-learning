import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type Transition from '@ember/routing/transition';
import type SessionService from 'ember-learning/services/session';

export default class LoginRoute extends Route {
  @service declare session: SessionService;
  @service declare router: RouterService;

  beforeModel(): Transition | void {
    // If already authenticated, redirect to dashboard
    if (this.session.isAuthenticated) {
      return this.router.transitionTo('dashboard');
    }
  }
}
