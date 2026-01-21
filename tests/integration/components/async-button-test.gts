import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click, waitFor } from '@ember/test-helpers';
import { AsyncButton } from 'ember-learning/components/async-button';

module('Integration | Component | async-button', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with default label', async function (assert) {
    const onClick = async () => {};

    await render(<template><AsyncButton @onClick={{onClick}} /></template>);

    assert.dom('[data-test-async-button]').hasText('Submit');
  });

  test('it renders with custom label', async function (assert) {
    const onClick = async () => {};

    await render(
      <template><AsyncButton @onClick={{onClick}} @label="Save" /></template>
    );

    assert.dom('[data-test-async-button]').hasText('Save');
  });

  test('it shows loading state during async operation', async function (assert) {
    let resolvePromise: () => void;
    const onClick = () =>
      new Promise<void>((resolve) => {
        resolvePromise = resolve;
      });

    await render(
      <template>
        <AsyncButton
          @onClick={{onClick}}
          @label="Save"
          @loadingLabel="Saving..."
        />
      </template>
    );

    assert.dom('[data-test-async-button]').hasText('Save');
    assert
      .dom('[data-test-async-button]')
      .doesNotHaveAttribute('data-test-async-button-loading');

    // Start the click but don't await it yet
    const clickPromise = click('[data-test-async-button]');

    // Wait for loading state
    await waitFor('[data-test-async-button-loading]');
    assert.dom('[data-test-async-button]').hasText('Saving...');
    assert.dom('[data-test-async-button]').isDisabled();

    // Resolve the promise
    resolvePromise!();
    await clickPromise;
  });

  test('it shows success state after completion', async function (assert) {
    let resolvePromise: () => void;
    const onClick = () =>
      new Promise<void>((resolve) => {
        resolvePromise = resolve;
      });

    await render(
      <template>
        <AsyncButton
          @onClick={{onClick}}
          @label="Save"
          @successLabel="Saved!"
          @successDuration={{5000}}
        />
      </template>
    );

    // Start the click
    const clickPromise = click('[data-test-async-button]');

    // Wait for loading state
    await waitFor('[data-test-async-button-loading]');

    // Resolve the onClick promise
    resolvePromise!();

    // Wait for success state (will appear before successDuration timeout)
    await waitFor('[data-test-async-button-success]');
    assert.dom('[data-test-async-button]').hasText('Saved!');

    // Don't wait for the full clickPromise since successDuration is long
    void clickPromise;
  });

  test('it shows error state when onClick throws', async function (assert) {
    const onClick = () => {
      throw new Error('Something went wrong');
    };

    await render(
      <template>
        <AsyncButton @onClick={{onClick}} @label="Save" @errorLabel="Failed!" />
      </template>
    );

    await click('[data-test-async-button]');

    assert
      .dom('[data-test-async-button]')
      .hasAttribute('data-test-async-button-error');
    assert.dom('[data-test-async-button]').hasText('Failed!');
  });

  test('it is disabled during loading', async function (assert) {
    let resolvePromise: () => void;
    const onClick = () =>
      new Promise<void>((resolve) => {
        resolvePromise = resolve;
      });

    await render(<template><AsyncButton @onClick={{onClick}} /></template>);

    assert.dom('[data-test-async-button]').isNotDisabled();

    const clickPromise = click('[data-test-async-button]');

    await waitFor('[data-test-async-button-loading]');
    assert.dom('[data-test-async-button]').isDisabled();

    resolvePromise!();
    await clickPromise;
  });

  test('it returns to idle after success duration', async function (assert) {
    const onClick = async () => {};

    await render(
      <template>
        <AsyncButton
          @onClick={{onClick}}
          @label="Save"
          @successDuration={{50}}
        />
      </template>
    );

    await click('[data-test-async-button]');

    // After success duration, should return to idle
    // waitForPromise in component ensures this completes
    assert.dom('[data-test-async-button]').hasText('Save');
    assert
      .dom('[data-test-async-button]')
      .doesNotHaveAttribute('data-test-async-button-success');
  });
});
