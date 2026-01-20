import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type SessionService from 'ember-learning/services/session';

export class DashboardRoute extends Route {
  @service declare session: SessionService;
  @service declare router: RouterService;

  async beforeModel(): Promise<void> {
    await this.session.restoreSession();
    if (!this.session.isAuthenticated) {
      this.router.transitionTo('login');
    }
  }

  model(): { userName: string; handleLogout: () => void } {
    const route = this;
    return {
      userName: this.session.currentUser?.name || 'User',
      handleLogout: () => {
        route.session.logout();
        route.router.transitionTo('login');
      }
    };
  }
}
