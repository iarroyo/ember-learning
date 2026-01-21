import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click } from '@ember/test-helpers';
import { UserCard } from 'ember-learning/components/user-card';
import type { User } from 'ember-learning/components/user-card';

module('Integration | Component | user-card', function (hooks) {
  setupRenderingTest(hooks);

  test('it displays the full name', async function (assert) {
    const user: User = {
      firstName: 'John',
      lastName: 'Smith',
      email: 'john@example.com',
      isOnline: false,
    };

    await render(<template><UserCard @user={{user}} /></template>);

    assert.dom('[data-test-full-name]').hasText('John Smith');
  });

  test('it displays the email address', async function (assert) {
    const user: User = {
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      isOnline: true,
    };

    await render(<template><UserCard @user={{user}} /></template>);

    assert.dom('[data-test-email]').hasText('jane@example.com');
  });

  test('it shows avatar image when provided', async function (assert) {
    const user: User = {
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      avatar: 'https://example.com/avatar.jpg',
      isOnline: true,
    };

    await render(<template><UserCard @user={{user}} /></template>);

    assert.dom('[data-test-avatar]').exists();
    assert
      .dom('[data-test-avatar]')
      .hasAttribute('src', 'https://example.com/avatar.jpg');
    assert.dom('[data-test-initials]').doesNotExist();
  });

  test('it shows initials when no avatar is provided', async function (assert) {
    const user: User = {
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      isOnline: true,
    };

    await render(<template><UserCard @user={{user}} /></template>);

    assert.dom('[data-test-initials]').exists();
    assert.dom('[data-test-initials]').hasText('JD');
    assert.dom('[data-test-avatar]').doesNotExist();
  });

  test('it shows online status indicator', async function (assert) {
    const onlineUser: User = {
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      isOnline: true,
    };

    await render(<template><UserCard @user={{onlineUser}} /></template>);

    assert.dom('[data-test-status]').hasClass('online');
    assert.dom('[data-test-status]').hasText('Online');
  });

  test('it shows offline status indicator', async function (assert) {
    const offlineUser: User = {
      firstName: 'John',
      lastName: 'Smith',
      email: 'john@example.com',
      isOnline: false,
    };

    await render(<template><UserCard @user={{offlineUser}} /></template>);

    assert.dom('[data-test-status]').hasClass('offline');
    assert.dom('[data-test-status]').hasText('Offline');
  });

  test('it shows premium badge when user is premium', async function (assert) {
    const premiumUser: User = {
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      isOnline: true,
      isPremium: true,
    };

    await render(<template><UserCard @user={{premiumUser}} /></template>);

    assert.dom('[data-test-premium-badge]').exists();
  });

  test('it hides premium badge when user is not premium', async function (assert) {
    const regularUser: User = {
      firstName: 'John',
      lastName: 'Smith',
      email: 'john@example.com',
      isOnline: true,
      isPremium: false,
    };

    await render(<template><UserCard @user={{regularUser}} /></template>);

    assert.dom('[data-test-premium-badge]').doesNotExist();
  });

  test('contact button calls onContact with user object', async function (assert) {
    assert.expect(2);

    const user: User = {
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      isOnline: true,
    };

    const handleContact = (contactedUser: User): void => {
      assert.strictEqual(
        contactedUser,
        user,
        'onContact called with user object'
      );
    };

    await render(
      <template>
        <UserCard @user={{user}} @onContact={{handleContact}} />
      </template>
    );

    assert.dom('[data-test-contact-button]').exists();
    await click('[data-test-contact-button]');
  });

  test('contact button is disabled when onContact is not provided', async function (assert) {
    const user: User = {
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      isOnline: true,
    };

    await render(<template><UserCard @user={{user}} /></template>);

    assert.dom('[data-test-contact-button]').isDisabled();
  });
});
