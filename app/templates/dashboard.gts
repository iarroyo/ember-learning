import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import { on } from '@ember/modifier';
import type RouterService from '@ember/routing/router-service';
import type SessionService from 'ember-learning/services/session';

export default class DashboardTemplate extends Component {
  @service declare router: RouterService;
  @service declare session: SessionService;

  get userName(): string {
    return this.session.currentUser?.name ?? '';
  }

  logout = () => {
    this.session.logout();
    this.router.transitionTo('login');
  };

  <template>
    <div>
      <h1>Dashboard</h1>
      <p>Welcome, <span data-test-user-name>{{this.userName}}</span>!</p>
      <button data-test-logout-button type="button" {{on "click" this.logout}}>
        Logout
      </button>
    </div>
  </template>
}
