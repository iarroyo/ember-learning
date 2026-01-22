import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';
import { on } from '@ember/modifier';
import type SessionService from 'ember-learning/services/session';
import { not } from 'ember-learning/helpers/not';

interface LoginFormSignature {
  Args: {
    onSuccess?: () => void;
  };
  Element: HTMLFormElement;
}

export class LoginForm extends Component<LoginFormSignature> {
  @service declare session: SessionService;

  @tracked email = '';
  @tracked password = '';
  @tracked isLoading = false;
  @tracked error: string | null = null;

  get isValid(): boolean {
    return this.email.length > 0 && this.password.length > 0;
  }

  @action
  async handleSubmit(event: Event): Promise<void> {
    event.preventDefault();

    if (!this.isValid) {
      return;
    }

    this.isLoading = true;
    this.error = null;

    try {
      await this.session.login({
        email: this.email,
        password: this.password,
      });

      if (this.args.onSuccess) {
        this.args.onSuccess();
      }
    } catch (err) {
      this.error = (err as Error).message || 'Invalid email or password';
    } finally {
      this.isLoading = false;
    }
  }

  @action
  updateEmail(event: Event): void {
    this.email = (event.target as HTMLInputElement).value;
  }

  @action
  updatePassword(event: Event): void {
    this.password = (event.target as HTMLInputElement).value;
  }

  <template>
    <form {{on "submit" this.handleSubmit}}>
      <div>
        <label for="login-email">Email</label>
        <input
          id="login-email"
          data-test-email-input
          type="email"
          value={{this.email}}
          autocomplete="email"
          aria-describedby={{if this.error "login-error"}}
          {{on "input" this.updateEmail}}
        />
      </div>
      <div>
        <label for="login-password">Password</label>
        <input
          id="login-password"
          data-test-password-input
          type="password"
          value={{this.password}}
          autocomplete="current-password"
          aria-describedby={{if this.error "login-error"}}
          {{on "input" this.updatePassword}}
        />
      </div>

      <div aria-live="polite" aria-atomic="true">
        {{#if this.isLoading}}
          <div data-test-loading>Loading...</div>
        {{/if}}

        {{#if this.error}}
          <div
            id="login-error"
            data-test-error
            role="alert"
          >{{this.error}}</div>
        {{/if}}
      </div>

      <button
        data-test-submit-button
        type="submit"
        disabled={{not this.isValid}}
        aria-disabled={{not this.isValid}}
      >
        Submit
      </button>
    </form>
  </template>
}
