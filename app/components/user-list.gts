import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import type Owner from '@ember/owner';
import { AsyncResource } from 'ember-learning/utils/async-resource';
import { getMockFailure } from 'ember-learning/utils/mock-api';
import type { User } from 'ember-learning/components/user-card';
import { UserCard } from 'ember-learning/components/user-card';

interface UserListSignature {
  Args: {
    onContact?: (user: User) => void;
  };
  Element: HTMLDivElement;
}

const mockUsers: User[] = [
  {
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    isOnline: true,
    isPremium: true,
  },
  {
    firstName: 'Jane',
    lastName: 'Smith',
    email: 'jane@example.com',
    isOnline: false,
    isPremium: false,
  },
  {
    firstName: 'Bob',
    lastName: 'Johnson',
    email: 'bob@example.com',
    isOnline: true,
    isPremium: false,
  },
  {
    firstName: 'Alice',
    lastName: 'Williams',
    email: 'alice@example.com',
    isOnline: true,
    isPremium: true,
  },
];

async function fetchUsers(): Promise<User[]> {
  await new Promise((resolve) => setTimeout(resolve, 800));

  if (getMockFailure()) {
    throw new Error('Failed to fetch users');
  }

  return mockUsers;
}

export class UserList extends Component<UserListSignature> {
  @tracked resource = new AsyncResource(fetchUsers);

  constructor(owner: Owner, args: UserListSignature['Args']) {
    super(owner, args);
    void this.resource.load();
  }

  @action
  retry(): void {
    void this.resource.retry();
  }

  <template>
    <div aria-live="polite" aria-busy={{this.resource.isLoading}}>
      {{#if this.resource.isLoading}}
        {{! Loading Skeleton }}
        <div
          data-test-skeleton
          role="status"
          class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4"
        >
          <div class="bg-card rounded-lg border p-6 animate-pulse">
            <div class="flex flex-col items-center">
              <div class="w-20 h-20 rounded-full bg-muted mb-4"></div>
              <div class="h-5 w-32 bg-muted rounded mb-2"></div>
              <div class="h-4 w-40 bg-muted rounded mb-1"></div>
              <div class="h-3 w-16 bg-muted rounded mb-4"></div>
              <div class="h-9 w-full bg-muted rounded-lg"></div>
            </div>
          </div>
          <div class="bg-card rounded-lg border p-6 animate-pulse">
            <div class="flex flex-col items-center">
              <div class="w-20 h-20 rounded-full bg-muted mb-4"></div>
              <div class="h-5 w-32 bg-muted rounded mb-2"></div>
              <div class="h-4 w-40 bg-muted rounded mb-1"></div>
              <div class="h-3 w-16 bg-muted rounded mb-4"></div>
              <div class="h-9 w-full bg-muted rounded-lg"></div>
            </div>
          </div>
          <div
            class="bg-card rounded-lg border p-6 animate-pulse hidden sm:block"
          >
            <div class="flex flex-col items-center">
              <div class="w-20 h-20 rounded-full bg-muted mb-4"></div>
              <div class="h-5 w-32 bg-muted rounded mb-2"></div>
              <div class="h-4 w-40 bg-muted rounded mb-1"></div>
              <div class="h-3 w-16 bg-muted rounded mb-4"></div>
              <div class="h-9 w-full bg-muted rounded-lg"></div>
            </div>
          </div>
          <div
            class="bg-card rounded-lg border p-6 animate-pulse hidden lg:block"
          >
            <div class="flex flex-col items-center">
              <div class="w-20 h-20 rounded-full bg-muted mb-4"></div>
              <div class="h-5 w-32 bg-muted rounded mb-2"></div>
              <div class="h-4 w-40 bg-muted rounded mb-1"></div>
              <div class="h-3 w-16 bg-muted rounded mb-4"></div>
              <div class="h-9 w-full bg-muted rounded-lg"></div>
            </div>
          </div>
          <span class="sr-only">Loading users...</span>
        </div>
      {{else if this.resource.isError}}
        {{! Error State }}
        <div
          data-test-error
          role="alert"
          class="flex flex-col items-center justify-center p-8 text-center bg-destructive/10 rounded-lg border border-destructive/20"
        >
          <svg
            class="w-12 h-12 text-destructive mb-4"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
            />
          </svg>
          <h3 class="text-lg font-semibold text-destructive mb-2">
            Error loading users
          </h3>
          <p class="text-muted-foreground mb-4">
            Something went wrong while fetching the user list. Please try again.
          </p>
          <button
            data-test-retry-button
            type="button"
            class="px-4 py-2 bg-destructive text-destructive-foreground font-medium rounded-lg hover:bg-destructive/90 transition-colors flex items-center gap-2"
            {{on "click" this.retry}}
          >
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
                d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
              />
            </svg>
            Retry
          </button>
        </div>
      {{else if this.resource.isSuccess}}
        {{! User Grid }}
        <ul
          role="list"
          aria-label="Users"
          class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4"
        >
          {{#each this.resource.data as |user|}}
            <li
              data-test-user-card
              class="bg-card rounded-lg border hover:shadow-lg transition-shadow"
            >
              <UserCard @user={{user}} @onContact={{@onContact}} />
              <span class="sr-only" data-test-user-name>
                {{user.firstName}}
                {{user.lastName}}
              </span>
            </li>
          {{/each}}
        </ul>

        {{! Empty State }}
        {{#unless this.resource.data.length}}
          <div
            class="flex flex-col items-center justify-center p-8 text-center"
          >
            <svg
              class="w-16 h-16 text-muted-foreground/50 mb-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="1.5"
                d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
              />
            </svg>
            <h3 class="text-lg font-medium text-foreground">No users found</h3>
            <p class="text-muted-foreground mt-1">
              There are no users to display at this time.
            </p>
          </div>
        {{/unless}}
      {{/if}}
    </div>
  </template>
}
