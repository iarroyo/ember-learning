import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, fillIn, blur, click } from '@ember/test-helpers';
import { RegistrationForm } from 'ember-learning/components/registration-form';

module('Integration | Component | registration-form', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders all form fields', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    assert.dom('[data-test-username-input]').exists();
    assert.dom('[data-test-email-input]').exists();
    assert.dom('[data-test-password-input]').exists();
    assert.dom('[data-test-confirm-password-input]').exists();
    assert.dom('[data-test-submit-button]').exists();
  });

  test('submit button is disabled initially', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    assert.dom('[data-test-submit-button]').isDisabled();
  });

  // Username validation tests
  test('shows error for username less than 3 characters', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-username-input]', 'ab');
    await blur('[data-test-username-input]');

    assert.dom('[data-test-username-error]').exists();
    assert
      .dom('[data-test-username-error]')
      .containsText('at least 3 characters');
  });

  test('shows error for username with invalid characters', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-username-input]', 'user@name!');
    await blur('[data-test-username-input]');

    assert.dom('[data-test-username-error]').exists();
    assert.dom('[data-test-username-error]').containsText('alphanumeric');
  });

  test('no error for valid username', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-username-input]', 'valid_user123');
    await blur('[data-test-username-input]');

    assert.dom('[data-test-username-error]').doesNotExist();
  });

  // Email validation tests
  test('shows error for invalid email format', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-email-input]', 'invalid-email');
    await blur('[data-test-email-input]');

    assert.dom('[data-test-email-error]').exists();
    assert.dom('[data-test-email-error]').containsText('valid email');
  });

  test('no error for valid email', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-email-input]', 'user@example.com');
    await blur('[data-test-email-input]');

    assert.dom('[data-test-email-error]').doesNotExist();
  });

  // Password validation tests
  test('shows error for password less than 8 characters', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'Short1');
    await blur('[data-test-password-input]');

    assert.dom('[data-test-password-error]').exists();
    assert.dom('[data-test-password-error]').containsText('8 characters');
  });

  test('shows error for password without uppercase', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'lowercase123');
    await blur('[data-test-password-input]');

    assert.dom('[data-test-password-error]').exists();
    assert.dom('[data-test-password-error]').containsText('uppercase');
  });

  test('shows error for password without number', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'NoNumbersHere');
    await blur('[data-test-password-input]');

    assert.dom('[data-test-password-error]').exists();
    assert.dom('[data-test-password-error]').containsText('number');
  });

  test('no error for valid password', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'ValidPass123');
    await blur('[data-test-password-input]');

    assert.dom('[data-test-password-error]').doesNotExist();
  });

  // Password confirmation tests
  test('shows error when passwords do not match', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'ValidPass123');
    await fillIn('[data-test-confirm-password-input]', 'DifferentPass123');
    await blur('[data-test-confirm-password-input]');

    assert.dom('[data-test-confirm-password-error]').exists();
    assert.dom('[data-test-confirm-password-error]').containsText('match');
  });

  test('no error when passwords match', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'ValidPass123');
    await fillIn('[data-test-confirm-password-input]', 'ValidPass123');
    await blur('[data-test-confirm-password-input]');

    assert.dom('[data-test-confirm-password-error]').doesNotExist();
  });

  // Password strength indicator
  test('shows weak password strength', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'Weak1234');

    assert
      .dom('[data-test-password-strength]')
      .hasText('Password strength: Weak');
  });

  test('shows medium password strength', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'Medium1Pass');

    assert
      .dom('[data-test-password-strength]')
      .hasText('Password strength: Medium');
  });

  test('shows strong password strength', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-password-input]', 'Str0ng!Pass#2024');

    assert
      .dom('[data-test-password-strength]')
      .hasText('Password strength: Strong');
  });

  // Form submission
  test('enables submit button when all fields are valid', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-username-input]', 'valid_user');
    await blur('[data-test-username-input]');
    await fillIn('[data-test-email-input]', 'user@example.com');
    await blur('[data-test-email-input]');
    await fillIn('[data-test-password-input]', 'ValidPass123');
    await blur('[data-test-password-input]');
    await fillIn('[data-test-confirm-password-input]', 'ValidPass123');
    await blur('[data-test-confirm-password-input]');

    assert.dom('[data-test-submit-button]').isNotDisabled();
  });

  test('calls onSubmit with form data when submitted', async function (assert) {
    assert.expect(4);

    const handleSubmit = (data: {
      username: string;
      email: string;
      password: string;
    }) => {
      assert.strictEqual(data.username, 'valid_user');
      assert.strictEqual(data.email, 'user@example.com');
      assert.strictEqual(data.password, 'ValidPass123');
    };

    await render(
      <template><RegistrationForm @onSubmit={{handleSubmit}} /></template>
    );

    await fillIn('[data-test-username-input]', 'valid_user');
    await blur('[data-test-username-input]');
    await fillIn('[data-test-email-input]', 'user@example.com');
    await blur('[data-test-email-input]');
    await fillIn('[data-test-password-input]', 'ValidPass123');
    await blur('[data-test-password-input]');
    await fillIn('[data-test-confirm-password-input]', 'ValidPass123');
    await blur('[data-test-confirm-password-input]');

    await click('[data-test-submit-button]');

    assert.dom('[data-test-success-message]').exists();
  });

  test('clear button resets the form', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-username-input]', 'some_user');
    await fillIn('[data-test-email-input]', 'test@example.com');

    await click('[data-test-clear-button]');

    assert.dom('[data-test-username-input]').hasValue('');
    assert.dom('[data-test-email-input]').hasValue('');
  });

  // Errors only show after blur
  test('errors do not show before field is blurred', async function (assert) {
    await render(<template><RegistrationForm /></template>);

    await fillIn('[data-test-username-input]', 'ab');

    // Error should not show yet - field hasn't been blurred
    assert.dom('[data-test-username-error]').doesNotExist();
  });
});
