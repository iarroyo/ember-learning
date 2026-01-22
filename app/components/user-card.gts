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
  Element: HTMLElement;
}

export class UserCard extends Component<UserCardSignature> {
  get fullName(): string {
    return `${this.args.user.firstName} ${this.args.user.lastName}`;
  }

  get initials(): string {
    return `${this.args.user.firstName[0]}${this.args.user.lastName[0]}`.toUpperCase();
  }

  get statusText(): string {
    return this.args.user.isOnline ? 'Online' : 'Offline';
  }

  // Generate a gradient based on user name for avatar placeholder
  get avatarGradient(): string {
    const gradients = [
      'from-violet-500 to-purple-600',
      'from-cyan-500 to-blue-600',
      'from-emerald-500 to-teal-600',
      'from-orange-500 to-red-600',
      'from-pink-500 to-rose-600',
      'from-indigo-500 to-blue-600',
    ];
    const charCode = this.args.user.firstName.charCodeAt(0) || 0;
    const index = charCode % gradients.length;
    return gradients[index] ?? gradients[0]!;
  }

  @action
  handleContact(): void {
    if (this.args.onContact) {
      this.args.onContact(this.args.user);
    }
  }

  <template>
    <article
      aria-label="User card for {{this.fullName}}"
      class="flex flex-col items-center p-6 text-center"
    >
      {{! Avatar }}
      <div class="relative mb-4">
        {{#if @user.avatar}}
          <img
            data-test-avatar
            src={{@user.avatar}}
            alt="Avatar for {{this.fullName}}"
            class="w-20 h-20 rounded-full object-cover ring-2 ring-border"
          />
        {{else}}
          <div
            data-test-initials
            aria-hidden="true"
            class="w-20 h-20 rounded-full bg-gradient-to-br
              {{this.avatarGradient}}
              flex items-center justify-center text-white text-2xl font-bold ring-2 ring-border"
          >
            {{this.initials}}
          </div>
        {{/if}}

        {{! Online Status Indicator }}
        <span
          data-test-status
          role="status"
          aria-label="Status: {{this.statusText}}"
          class="absolute bottom-1 right-1 w-4 h-4 rounded-full border-2 border-card
            {{if @user.isOnline 'bg-green-500' 'bg-gray-400'}}"
        ></span>
      </div>

      {{! User Info }}
      <div class="space-y-1">
        <div class="flex items-center justify-center gap-2">
          <h3 data-test-full-name class="font-semibold text-foreground">
            {{this.fullName}}
          </h3>
          {{#if @user.isPremium}}
            <span
              data-test-premium-badge
              aria-label="Premium member"
              class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-gradient-to-r from-amber-400 to-yellow-500 text-amber-900"
            >
              <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                <path
                  d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
                />
              </svg>
              Premium
            </span>
          {{/if}}
        </div>
        <p data-test-email class="text-sm text-muted-foreground">
          {{@user.email}}
        </p>
        <p
          class="text-xs
            {{if
              @user.isOnline
              'text-green-600 dark:text-green-400'
              'text-muted-foreground'
            }}"
        >
          {{this.statusText}}
        </p>
      </div>

      {{! Contact Button }}
      <button
        data-test-contact-button
        type="button"
        aria-label="Contact {{this.fullName}}"
        aria-disabled={{not @onContact}}
        class="mt-4 w-full px-4 py-2 text-sm font-medium rounded-lg transition-colors
          {{if
            @onContact
            'bg-primary text-primary-foreground hover:bg-primary/90'
            'bg-muted text-muted-foreground cursor-not-allowed'
          }}"
        {{on "click" this.handleContact}}
        disabled={{not @onContact}}
      >
        <span class="flex items-center justify-center gap-2">
          <svg
            class="w-4 h-4"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
            />
          </svg>
          Contact
        </span>
      </button>
    </article>
  </template>
}
