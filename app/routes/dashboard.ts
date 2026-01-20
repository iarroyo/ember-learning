import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type Transition from '@ember/routing/transition';
import type SessionService from 'ember-learning/services/session';

export default class DashboardRoute extends Route {
  @service declare session: SessionService;
  @service declare router: RouterService;

  beforeModel(transition: Transition): void {
    // Synchronous check - restoreSession is only needed if there might be a token
    const token = localStorage.getItem('auth-token');
    if (token) {
      try {
        const decoded = atob(token);
        const [email] = decoded.split(':');
        if (email) {
          this.session.token = token;
          this.session.currentUser = { email, name: 'John Doe' };
          this.session.isAuthenticated = true;
          return;
        }
      } catch {
        localStorage.removeItem('auth-token');
      }
    }

    // Not authenticated - redirect to login
    this.session.attemptedTransition = transition;
    this.router.transitionTo('login');
  }
}
