import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type { SessionService } from 'ember-learning/services/session';

export class DashboardRoute extends Route {
  @service declare session: SessionService;

  async beforeModel(): Promise<void> {
    await this.session.restoreSession();
    if (!this.session.isAuthenticated) {
      this.transitionTo('login');
    }
  }

  model(): { userName: string; handleLogout: () => void } {
    const route = this;
    return {
      userName: this.session.currentUser?.name || 'User',
      handleLogout: () => {
        route.session.logout();
        route.transitionTo('login');
      }
    };
  }
}
