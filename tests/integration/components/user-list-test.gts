import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click, waitFor, waitUntil } from '@ember/test-helpers';
import { UserList } from 'ember-learning/components/user-list';
import { setMockFailure } from 'ember-learning/utils/mock-api';

module('Integration | Component | user-list', function (hooks) {
  setupRenderingTest(hooks);

  hooks.afterEach(function () {
    setMockFailure(false);
  });

  test('shows loading skeleton while fetching', async function (assert) {
    render(
      <template>
        <UserList />
      </template>
    );

    await waitFor('[data-test-skeleton]');
    assert.dom('[data-test-skeleton]').exists();
  });

  test('renders user list on success', async function (assert) {
    await render(
      <template>
        <UserList />
      </template>
    );

    await waitUntil(() => document.querySelector('[data-test-user-card]'));

    assert.dom('[data-test-user-card]').exists({ count: 4 });
    assert.dom('[data-test-user-name]').exists();
  });

  test('shows error with retry button on failure', async function (assert) {
    setMockFailure(true);

    await render(
      <template>
        <UserList />
      </template>
    );

    await waitFor('[data-test-error]');

    assert.dom('[data-test-error]').exists();
    assert.dom('[data-test-retry-button]').exists();

    // Fix the mock and retry
    setMockFailure(false);
    await click('[data-test-retry-button]');

    await waitFor('[data-test-user-card]');
    assert.dom('[data-test-user-card]').exists({ count: 4 });
  });
});
