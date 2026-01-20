import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type { SessionService } from 'ember-learning/services/session';

export class LoginRoute extends Route {
  @service declare session: SessionService;

  async beforeModel(): Promise<void> {
    await this.session.restoreSession();
    if (this.session.isAuthenticated) {
      this.transitionTo('dashboard');
    }
  }

  model(): { onSuccess: () => void } {
    const route = this;
    return {
      onSuccess: () => {
        route.transitionTo('dashboard');
      }
    };
  }
}
