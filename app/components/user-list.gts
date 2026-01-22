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
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

const mockUsers: User[] = [
  {
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    isOnline: true,
  },
  {
    firstName: 'Jane',
    lastName: 'Smith',
    email: 'jane@example.com',
    isOnline: false,
  },
  {
    firstName: 'Bob',
    lastName: 'Johnson',
    email: 'bob@example.com',
    isOnline: true,
  },
  {
    firstName: 'Alice',
    lastName: 'Williams',
    email: 'alice@example.com',
    isOnline: true,
  },
];

async function fetchUsers(): Promise<User[]> {
  await new Promise((resolve) => setTimeout(resolve, 100));

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
        <div data-test-skeleton role="status">Loading users...</div>
      {{else if this.resource.isError}}
        <div data-test-error role="alert">Error loading users</div>
        <button data-test-retry-button type="button" {{on "click" this.retry}}>
          Retry loading users
        </button>
      {{else if this.resource.isSuccess}}
        <ul role="list" aria-label="Users">
          {{#each this.resource.data as |user|}}
            <li data-test-user-card>
              <UserCard @user={{user}} />
              <div data-test-user-name>{{user.firstName}}
                {{user.lastName}}</div>
            </li>
          {{/each}}
        </ul>
      {{/if}}
    </div>
  </template>
}
