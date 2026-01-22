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
    <form class="space-y-4" {{on "submit" this.handleSubmit}}>
      <div class="space-y-2">
        <label
          for="login-email"
          class="block text-sm font-medium text-foreground"
        >
          Email
        </label>
        <input
          id="login-email"
          data-test-email-input
          type="email"
          value={{this.email}}
          autocomplete="email"
          placeholder="you@example.com"
          aria-describedby={{if this.error "login-error"}}
          class="w-full px-3 py-2 border border-input rounded-md bg-background text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent"
          {{on "input" this.updateEmail}}
        />
      </div>
      <div class="space-y-2">
        <label
          for="login-password"
          class="block text-sm font-medium text-foreground"
        >
          Password
        </label>
        <input
          id="login-password"
          data-test-password-input
          type="password"
          value={{this.password}}
          autocomplete="current-password"
          placeholder="••••••••"
          aria-describedby={{if this.error "login-error"}}
          class="w-full px-3 py-2 border border-input rounded-md bg-background text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent"
          {{on "input" this.updatePassword}}
        />
      </div>

      <div aria-live="polite" aria-atomic="true">
        {{#if this.isLoading}}
          <div
            data-test-loading
            class="flex items-center gap-2 text-sm text-muted-foreground"
          >
            <svg
              class="animate-spin h-4 w-4"
              fill="none"
              viewBox="0 0 24 24"
            >
              <circle
                class="opacity-25"
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                stroke-width="4"
              ></circle>
              <path
                class="opacity-75"
                fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
              ></path>
            </svg>
            Signing in...
          </div>
        {{/if}}

        {{#if this.error}}
          <div
            id="login-error"
            data-test-error
            role="alert"
            class="text-sm text-destructive bg-destructive/10 px-3 py-2 rounded-md"
          >
            {{this.error}}
          </div>
        {{/if}}
      </div>

      <button
        data-test-submit-button
        type="submit"
        disabled={{not this.isValid}}
        aria-disabled={{not this.isValid}}
        class="w-full px-4 py-2 bg-primary text-primary-foreground font-medium rounded-md hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
      >
        Sign In
      </button>
    </form>
  </template>
}
