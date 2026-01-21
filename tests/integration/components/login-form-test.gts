import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, fillIn, click, waitFor } from '@ember/test-helpers';
import { LoginForm } from 'ember-learning/components/login-form';

module('Integration | Component | login-form', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    localStorage.clear();
  });

  test('it renders login form fields', async function (assert) {
    await render(<template><LoginForm /></template>);

    assert.dom('[data-test-email-input]').exists();
    assert.dom('[data-test-password-input]').exists();
    assert.dom('[data-test-submit-button]').exists();
  });

  test('submit button is disabled when fields are empty', async function (assert) {
    await render(<template><LoginForm /></template>);

    assert.dom('[data-test-submit-button]').isDisabled();
  });

  test('submit button is enabled when fields are filled', async function (assert) {
    await render(<template><LoginForm /></template>);

    await fillIn('[data-test-email-input]', 'user@example.com');
    await fillIn('[data-test-password-input]', 'password123');

    assert.dom('[data-test-submit-button]').isNotDisabled();
  });

  test('shows loading state during login', async function (assert) {
    await render(<template><LoginForm /></template>);

    await fillIn('[data-test-email-input]', 'user@example.com');
    await fillIn('[data-test-password-input]', 'password123');

    // Click without waiting for completion
    void click('[data-test-submit-button]');

    // Check loading state appears
    await waitFor('[data-test-loading]');
    assert.dom('[data-test-loading]').exists();
  });

  test('shows error message for invalid credentials', async function (assert) {
    await render(<template><LoginForm /></template>);

    await fillIn('[data-test-email-input]', 'user@example.com');
    await fillIn('[data-test-password-input]', 'wrongpassword');
    await click('[data-test-submit-button]');

    assert.dom('[data-test-error]').exists();
    assert.dom('[data-test-error]').containsText('Invalid email or password');
  });

  test('calls onSuccess after successful login', async function (assert) {
    assert.expect(1);

    const handleSuccess = () => {
      assert.ok(true, 'onSuccess was called');
    };

    await render(
      <template><LoginForm @onSuccess={{handleSuccess}} /></template>
    );

    await fillIn('[data-test-email-input]', 'user@example.com');
    await fillIn('[data-test-password-input]', 'password123');
    await click('[data-test-submit-button]');
  });
});
