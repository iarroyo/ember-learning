import Component from '@glimmer/component';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { not } from 'ember-learning/helpers/not';

export interface User {
  firstName: string;
  lastName: string;
  email: string;
  isOnline: boolean;
  avatar?: string;
  isPremium?: boolean;
}

interface UserCardSignature {
  Args: {
    user: User;
    onContact?: (user: User) => void;
  };
  Element: HTMLDivElement;
}

export class UserCard extends Component<UserCardSignature> {
  get fullName(): string {
    return `${this.args.user.firstName} ${this.args.user.lastName}`;
  }

  get initials(): string {
    return `${this.args.user.firstName[0]}${this.args.user.lastName[0]}`.toUpperCase();
  }

  get statusClass(): string {
    return this.args.user.isOnline ? 'online' : 'offline';
  }

  get statusText(): string {
    return this.args.user.isOnline ? 'Online' : 'Offline';
  }

  @action
  handleContact(): void {
    if (this.args.onContact) {
      this.args.onContact(this.args.user);
    }
  }

  <template>
    <div>
      {{#if @user.avatar}}
        <img data-test-avatar src={{@user.avatar}} alt={{this.fullName}} />
      {{else}}
        <div data-test-initials>{{this.initials}}</div>
      {{/if}}

      <div data-test-full-name>{{this.fullName}}</div>
      <div data-test-email>{{@user.email}}</div>

      <div data-test-status class={{this.statusClass}}>
        {{this.statusText}}
      </div>

      {{#if @user.isPremium}}
        <div data-test-premium-badge>Premium</div>
      {{/if}}

      <button
        data-test-contact-button
        type="button"
        {{on "click" this.handleContact}}
        disabled={{not @onContact}}
      >
        Contact
      </button>
    </div>
  </template>
}
