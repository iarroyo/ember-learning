import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click, rerender } from '@ember/test-helpers';
import { Alert } from 'ember-learning/components/alert';
import { tracked } from '@glimmer/tracking';

module('Integration | Component | alert', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with default info variant', async function (assert) {
    await render(
      <template>
        <Alert>This is an alert</Alert>
      </template>
    );

    assert.dom('[data-test-alert]').exists();
    assert.dom('[data-test-alert]').hasClass('bg-blue-100');
    assert.dom('[data-test-alert]').hasClass('text-blue-800');
    assert.dom('[data-test-alert]').containsText('This is an alert');
  });

  test('it renders success variant', async function (assert) {
    await render(
      <template>
        <Alert @variant="success">Success!</Alert>
      </template>
    );

    assert.dom('[data-test-alert]').hasClass('bg-green-100');
    assert.dom('[data-test-alert]').hasClass('text-green-800');
  });

  test('it renders warning variant', async function (assert) {
    await render(
      <template>
        <Alert @variant="warning">Warning!</Alert>
      </template>
    );

    assert.dom('[data-test-alert]').hasClass('bg-yellow-100');
    assert.dom('[data-test-alert]').hasClass('text-yellow-800');
  });

  test('it renders error variant', async function (assert) {
    await render(
      <template>
        <Alert @variant="error">Error!</Alert>
      </template>
    );

    assert.dom('[data-test-alert]').hasClass('bg-red-100');
    assert.dom('[data-test-alert]').hasClass('text-red-800');
  });

  test('it does not show dismiss button by default', async function (assert) {
    await render(
      <template>
        <Alert>Message</Alert>
      </template>
    );

    assert.dom('[data-test-alert-dismiss]').doesNotExist();
  });

  test('it shows dismiss button when dismissible', async function (assert) {
    await render(
      <template>
        <Alert @dismissible={{true}}>Message</Alert>
      </template>
    );

    assert.dom('[data-test-alert-dismiss]').exists();
  });

  test('clicking dismiss hides the alert', async function (assert) {
    await render(
      <template>
        <Alert @dismissible={{true}}>Message</Alert>
      </template>
    );

    assert.dom('[data-test-alert]').exists();

    await click('[data-test-alert-dismiss]');

    assert.dom('[data-test-alert]').doesNotExist();
  });

  test('clicking dismiss calls onDismiss callback', async function (assert) {
    let dismissed = false;
    const handleDismiss = () => {
      dismissed = true;
    };

    await render(
      <template>
        <Alert @dismissible={{true}} @onDismiss={{handleDismiss}}>Message</Alert>
      </template>
    );

    await click('[data-test-alert-dismiss]');

    assert.true(dismissed, 'onDismiss was called');
  });

  test('it updates reactively when variant changes', async function (assert) {
    class State {
      @tracked variant: 'info' | 'success' | 'warning' | 'error' = 'info';
    }
    const state = new State();

    await render(
      <template>
        <Alert @variant={{state.variant}}>Message</Alert>
      </template>
    );

    assert.dom('[data-test-alert]').hasClass('bg-blue-100');

    state.variant = 'error';
    await rerender();

    assert.dom('[data-test-alert]').hasClass('bg-red-100');
    assert.dom('[data-test-alert]').doesNotHaveClass('bg-blue-100');
  });

  test('it has role="alert" for accessibility', async function (assert) {
    await render(
      <template>
        <Alert>Message</Alert>
      </template>
    );

    assert.dom('[data-test-alert]').hasAttribute('role', 'alert');
  });

  test('it spreads attributes to outer element', async function (assert) {
    await render(
      <template>
        <Alert class="custom-class" data-custom="test">Message</Alert>
      </template>
    );

    assert.dom('[data-test-alert]').hasClass('custom-class');
    assert.dom('[data-test-alert]').hasAttribute('data-custom', 'test');
  });
});
