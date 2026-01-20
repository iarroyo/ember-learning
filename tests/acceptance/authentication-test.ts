import { module, test } from 'qunit';
import { visit, currentURL, fillIn, click } from '@ember/test-helpers';
import { setupApplicationTest } from 'ember-qunit';

module('Acceptance | authentication', function (hooks) {
  setupApplicationTest(hooks);

  hooks.beforeEach(function () {
    localStorage.clear();
  });

  test('unauthenticated user is redirected from dashboard to login', async function (assert) {
    await visit('/dashboard');

    assert.strictEqual(currentURL(), '/login');
  });

  test('successful login redirects to dashboard', async function (assert) {
    await visit('/login');

    await fillIn('[data-test-email-input]', 'user@example.com');
    await fillIn('[data-test-password-input]', 'password123');
    await click('[data-test-submit-button]');

    assert.strictEqual(currentURL(), '/dashboard');
    assert.dom('[data-test-user-name]').hasText('John Doe');
  });

  test('logout redirects to login page', async function (assert) {
    // First login
    await visit('/login');
    await fillIn('[data-test-email-input]', 'user@example.com');
    await fillIn('[data-test-password-input]', 'password123');
    await click('[data-test-submit-button]');

    // Then logout
    await click('[data-test-logout-button]');

    assert.strictEqual(currentURL(), '/login');
  });

  test('session persists across page refresh', async function (assert) {
    // Login first
    await visit('/login');
    await fillIn('[data-test-email-input]', 'user@example.com');
    await fillIn('[data-test-password-input]', 'password123');
    await click('[data-test-submit-button]');

    // Simulate refresh by visiting dashboard directly
    await visit('/dashboard');

    assert.strictEqual(currentURL(), '/dashboard');
    assert.dom('[data-test-user-name]').exists();
  });

  test('intended transition is preserved after login', async function (assert) {
    // Try to visit protected route
    await visit('/dashboard');

    // Should be at login
    assert.strictEqual(currentURL(), '/login');

    // Login
    await fillIn('[data-test-email-input]', 'user@example.com');
    await fillIn('[data-test-password-input]', 'password123');
    await click('[data-test-submit-button]');

    // Should be redirected to original destination
    assert.strictEqual(currentURL(), '/dashboard');
  });
});
