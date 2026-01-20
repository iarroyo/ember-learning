import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import type SessionService from 'ember-learning/services/session';

module('Unit | Service | session', function (hooks) {
  setupTest(hooks);

  hooks.beforeEach(function () {
    // Clear localStorage before each test
    localStorage.clear();
  });

  test('it starts as unauthenticated', function (assert) {
    const service = this.owner.lookup('service:session') as SessionService;

    assert.false(service.isAuthenticated);
    assert.strictEqual(service.currentUser, null);
    assert.strictEqual(service.token, null);
  });

  test('login authenticates user and stores token', async function (assert) {
    const service = this.owner.lookup('service:session') as SessionService;

    await service.login({
      email: 'user@example.com',
      password: 'password123'
    });

    assert.true(service.isAuthenticated);
    assert.strictEqual(service.currentUser?.email, 'user@example.com');
    assert.ok(service.token);
    assert.ok(localStorage.getItem('auth-token'));
  });

  test('login throws error for invalid credentials', async function (assert) {
    const service = this.owner.lookup('service:session') as SessionService;

    try {
      await service.login({
        email: 'user@example.com',
        password: 'wrongpassword'
      });
      assert.ok(false, 'Should have thrown');
    } catch (error) {
      assert.strictEqual((error as Error).message, 'Invalid email or password');
    }

    assert.false(service.isAuthenticated);
  });

  test('logout clears session and removes token', async function (assert) {
    const service = this.owner.lookup('service:session') as SessionService;

    await service.login({
      email: 'user@example.com',
      password: 'password123'
    });

    assert.true(service.isAuthenticated);

    service.logout();

    assert.false(service.isAuthenticated);
    assert.strictEqual(service.currentUser, null);
    assert.strictEqual(service.token, null);
    assert.strictEqual(localStorage.getItem('auth-token'), null);
  });

  test('restoreSession restores from localStorage', async function (assert) {
    // Pre-set a valid token
    const token = btoa('user@example.com:' + Date.now());
    localStorage.setItem('auth-token', token);

    const service = this.owner.lookup('service:session') as SessionService;
    await service.restoreSession();

    assert.true(service.isAuthenticated);
    assert.strictEqual(service.currentUser?.email, 'user@example.com');
  });

  test('restoreSession handles invalid token gracefully', async function (assert) {
    localStorage.setItem('auth-token', 'invalid-token');

    const service = this.owner.lookup('service:session') as SessionService;
    await service.restoreSession();

    assert.false(service.isAuthenticated);
    assert.strictEqual(localStorage.getItem('auth-token'), null);
  });
});
