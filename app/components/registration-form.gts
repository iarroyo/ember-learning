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

  <template>
    <form {{on "submit" this.handleSubmit}}>
      <input
        data-test-username-input
        type="text"
        value={{this.username}}
        {{on "input" this.updateUsername}}
        {{on "blur" this.handleUsernameBlur}}
      />
      {{#if this.usernameError}}
        <div data-test-username-error>{{this.usernameError}}</div>
      {{/if}}

      <input
        data-test-email-input
        type="email"
        value={{this.email}}
        {{on "input" this.updateEmail}}
        {{on "blur" this.handleEmailBlur}}
      />
      {{#if this.emailError}}
        <div data-test-email-error>{{this.emailError}}</div>
      {{/if}}

      <input
        data-test-password-input
        type="password"
        value={{this.password}}
        {{on "input" this.updatePassword}}
        {{on "blur" this.handlePasswordBlur}}
      />
      {{#if this.passwordError}}
        <div data-test-password-error>{{this.passwordError}}</div>
      {{/if}}
      {{#if this.passwordStrength}}
        <div data-test-password-strength>{{this.passwordStrength}}</div>
      {{/if}}

      <input
        data-test-confirm-password-input
        type="password"
        value={{this.confirmPassword}}
        {{on "input" this.updateConfirmPassword}}
        {{on "blur" this.handleConfirmPasswordBlur}}
      />
      {{#if this.confirmPasswordError}}
        <div
          data-test-confirm-password-error
        >{{this.confirmPasswordError}}</div>
      {{/if}}

      <button
        data-test-submit-button
        type="submit"
        disabled={{not this.isValid}}
      >
        Submit
      </button>

      <button data-test-clear-button type="button" {{on "click" this.clear}}>
        Clear
      </button>

      {{#if this.submitted}}
        <div data-test-success-message>Registration successful!</div>
      {{/if}}
    </form>
  </template>
}
