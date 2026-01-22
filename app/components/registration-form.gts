import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { not } from 'ember-learning/helpers/not';

interface RegistrationFormSignature {
  Args: {
    onSubmit?: (data: {
      username: string;
      email: string;
      password: string;
    }) => void;
  };
  Element: HTMLFormElement;
}

export class RegistrationForm extends Component<RegistrationFormSignature> {
  @tracked username = '';
  @tracked email = '';
  @tracked password = '';
  @tracked confirmPassword = '';
  @tracked usernameTouched = false;
  @tracked emailTouched = false;
  @tracked passwordTouched = false;
  @tracked confirmPasswordTouched = false;
  @tracked submitted = false;

  get usernameError(): string | null {
    if (!this.usernameTouched) return null;
    if (this.username.length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (!/^[a-zA-Z0-9_]+$/.test(this.username)) {
      return 'Username must be alphanumeric';
    }
    return null;
  }

  get emailError(): string | null {
    if (!this.emailTouched) return null;
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(this.email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  get passwordError(): string | null {
    if (!this.passwordTouched) return null;
    if (this.password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!/[A-Z]/.test(this.password)) {
      return 'Password must contain an uppercase letter';
    }
    if (!/[0-9]/.test(this.password)) {
      return 'Password must contain a number';
    }
    return null;
  }

  get confirmPasswordError(): string | null {
    if (!this.confirmPasswordTouched) return null;
    if (this.password !== this.confirmPassword) {
      return 'Passwords must match';
    }
    return null;
  }

  get passwordStrength(): string {
    if (this.password.length === 0) return '';

    const hasUppercase = /[A-Z]/.test(this.password);
    const hasNumber = /[0-9]/.test(this.password);
    const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(this.password);

    // Doesn't meet basic requirements
    if (this.password.length < 8 || !hasUppercase || !hasNumber) {
      return 'Weak';
    }

    // Long (12+) with special chars = Strong
    if (this.password.length >= 12 && hasSpecialChar) {
      return 'Strong';
    }

    // Medium length (11+) or has special chars = Medium
    if (this.password.length >= 11 || hasSpecialChar) {
      return 'Medium';
    }

    // Just meets minimum (8-10 chars, no special) = Weak
    return 'Weak';
  }

  get isValid(): boolean {
    return (
      !this.usernameError &&
      !this.emailError &&
      !this.passwordError &&
      !this.confirmPasswordError &&
      this.username.length > 0 &&
      this.email.length > 0 &&
      this.password.length > 0 &&
      this.confirmPassword.length > 0
    );
  }

  @action
  updateUsername(event: Event): void {
    this.username = (event.target as HTMLInputElement).value;
  }

  @action
  updateEmail(event: Event): void {
    this.email = (event.target as HTMLInputElement).value;
  }

  @action
  updatePassword(event: Event): void {
    this.password = (event.target as HTMLInputElement).value;
  }

  @action
  updateConfirmPassword(event: Event): void {
    this.confirmPassword = (event.target as HTMLInputElement).value;
  }

  @action
  handleUsernameBlur(): void {
    this.usernameTouched = true;
  }

  @action
  handleEmailBlur(): void {
    this.emailTouched = true;
  }

  @action
  handlePasswordBlur(): void {
    this.passwordTouched = true;
  }

  @action
  handleConfirmPasswordBlur(): void {
    this.confirmPasswordTouched = true;
  }

  @action
  handleSubmit(event: Event): void {
    event.preventDefault();

    if (this.isValid && this.args.onSubmit) {
      this.args.onSubmit({
        username: this.username,
        email: this.email,
        password: this.password,
      });
      this.submitted = true;
    }
  }

  @action
  clear(): void {
    this.username = '';
    this.email = '';
    this.password = '';
    this.confirmPassword = '';
    this.usernameTouched = false;
    this.emailTouched = false;
    this.passwordTouched = false;
    this.confirmPasswordTouched = false;
    this.submitted = false;
  }

  get passwordStrengthColor(): string {
    switch (this.passwordStrength) {
      case 'Weak':
        return 'text-destructive';
      case 'Medium':
        return 'text-yellow-600 dark:text-yellow-500';
      case 'Strong':
        return 'text-green-600 dark:text-green-500';
      default:
        return 'text-muted-foreground';
    }
  }

  <template>
    <form class="space-y-4" {{on "submit" this.handleSubmit}}>
      <div class="space-y-2">
        <label
          for="reg-username"
          class="block text-sm font-medium text-foreground"
        >
          Username
        </label>
        <input
          id="reg-username"
          data-test-username-input
          type="text"
          value={{this.username}}
          autocomplete="username"
          placeholder="johndoe"
          aria-describedby={{if this.usernameError "reg-username-error"}}
          aria-invalid={{if this.usernameError "true"}}
          class="w-full px-3 py-2 border rounded-md bg-background text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent
            {{if this.usernameError 'border-destructive' 'border-input'}}"
          {{on "input" this.updateUsername}}
          {{on "blur" this.handleUsernameBlur}}
        />
        {{#if this.usernameError}}
          <div
            id="reg-username-error"
            data-test-username-error
            role="alert"
            class="text-sm text-destructive"
          >
            {{this.usernameError}}
          </div>
        {{/if}}
      </div>

      <div class="space-y-2">
        <label
          for="reg-email"
          class="block text-sm font-medium text-foreground"
        >
          Email
        </label>
        <input
          id="reg-email"
          data-test-email-input
          type="email"
          value={{this.email}}
          autocomplete="email"
          placeholder="you@example.com"
          aria-describedby={{if this.emailError "reg-email-error"}}
          aria-invalid={{if this.emailError "true"}}
          class="w-full px-3 py-2 border rounded-md bg-background text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent
            {{if this.emailError 'border-destructive' 'border-input'}}"
          {{on "input" this.updateEmail}}
          {{on "blur" this.handleEmailBlur}}
        />
        {{#if this.emailError}}
          <div
            id="reg-email-error"
            data-test-email-error
            role="alert"
            class="text-sm text-destructive"
          >
            {{this.emailError}}
          </div>
        {{/if}}
      </div>

      <div class="space-y-2">
        <label
          for="reg-password"
          class="block text-sm font-medium text-foreground"
        >
          Password
        </label>
        {{! template-lint-disable no-unsupported-role-attributes }}
        <input
          id="reg-password"
          data-test-password-input
          type="password"
          value={{this.password}}
          autocomplete="new-password"
          placeholder="••••••••"
          aria-describedby="reg-password-hint {{if
            this.passwordError
            'reg-password-error'
          }}"
          aria-invalid={{if this.passwordError "true"}}
          class="w-full px-3 py-2 border rounded-md bg-background text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent
            {{if this.passwordError 'border-destructive' 'border-input'}}"
          {{on "input" this.updatePassword}}
          {{on "blur" this.handlePasswordBlur}}
        />
        {{#if this.passwordError}}
          <div
            id="reg-password-error"
            data-test-password-error
            role="alert"
            class="text-sm text-destructive"
          >
            {{this.passwordError}}
          </div>
        {{/if}}
        {{#if this.passwordStrength}}
          <div
            id="reg-password-hint"
            data-test-password-strength
            aria-live="polite"
            class="text-sm {{this.passwordStrengthColor}}"
          >
            Password strength:
            <span class="font-medium">{{this.passwordStrength}}</span>
          </div>
        {{/if}}
      </div>

      <div class="space-y-2">
        <label
          for="reg-confirm-password"
          class="block text-sm font-medium text-foreground"
        >
          Confirm Password
        </label>
        {{! template-lint-disable no-unsupported-role-attributes }}
        <input
          id="reg-confirm-password"
          data-test-confirm-password-input
          type="password"
          value={{this.confirmPassword}}
          autocomplete="new-password"
          placeholder="••••••••"
          aria-describedby={{if
            this.confirmPasswordError
            "reg-confirm-password-error"
          }}
          aria-invalid={{if this.confirmPasswordError "true"}}
          class="w-full px-3 py-2 border rounded-md bg-background text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:border-transparent
            {{if
              this.confirmPasswordError
              'border-destructive'
              'border-input'
            }}"
          {{on "input" this.updateConfirmPassword}}
          {{on "blur" this.handleConfirmPasswordBlur}}
        />
        {{#if this.confirmPasswordError}}
          <div
            id="reg-confirm-password-error"
            data-test-confirm-password-error
            role="alert"
            class="text-sm text-destructive"
          >
            {{this.confirmPasswordError}}
          </div>
        {{/if}}
      </div>

      <div class="flex gap-3 pt-2">
        <button
          data-test-submit-button
          type="submit"
          disabled={{not this.isValid}}
          aria-disabled={{not this.isValid}}
          class="flex-1 px-4 py-2 bg-primary text-primary-foreground font-medium rounded-md hover:bg-primary/90 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          Register
        </button>

        <button
          data-test-clear-button
          type="button"
          class="px-4 py-2 border border-input bg-background text-foreground font-medium rounded-md hover:bg-muted focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 transition-colors"
          {{on "click" this.clear}}
        >
          Clear
        </button>
      </div>

      {{#if this.submitted}}
        <div
          data-test-success-message
          role="status"
          aria-live="polite"
          class="text-sm text-green-600 dark:text-green-500 bg-green-50 dark:bg-green-950 px-3 py-2 rounded-md"
        >
          Registration successful!
        </div>
      {{/if}}
    </form>
  </template>
}
