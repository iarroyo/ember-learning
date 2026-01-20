import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
import type SessionService from 'ember-learning/services/session';
import { LoginForm } from 'ember-learning/components/login-form';

export default class LoginTemplate extends Component {
  @service declare router: RouterService;
  @service declare session: SessionService;

  handleSuccess = () => {
    const attemptedTransition = this.session.attemptedTransition;
    if (attemptedTransition) {
      this.session.attemptedTransition = null;
      attemptedTransition.retry();
    } else {
      this.router.transitionTo('dashboard');
    }
  };

  <template>
    <div>
      <h1>Login</h1>
      <LoginForm @onSuccess={{this.handleSuccess}} />
    </div>
  </template>
}
