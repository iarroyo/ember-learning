import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type SessionService from 'ember-learning/services/session';

export class LoginRoute extends Route {
  @service declare session: SessionService;
  @service declare router: RouterService;

  beforeModel(): void {
    this.session.restoreSession();
    if (this.session.isAuthenticated) {
      this.router.transitionTo('dashboard');
    }
  }

  model(): { onSuccess: () => void } {
    return {
      onSuccess: () => {
        this.router.transitionTo('dashboard');
      },
    };
  }
}
