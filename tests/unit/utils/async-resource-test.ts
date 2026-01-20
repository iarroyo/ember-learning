import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import { AsyncResource } from 'ember-learning/utils/async-resource';

module('Unit | Utility | async-resource', function (hooks) {
  setupTest(hooks);

  test('initial state is idle', function (assert) {
    const resource = new AsyncResource(() => Promise.resolve('data'));

    assert.false(resource.isLoading);
    assert.false(resource.isError);
    assert.false(resource.isSuccess);
    assert.strictEqual(resource.data, null);
    assert.strictEqual(resource.error, null);
  });

  test('loading state is set while fetching', async function (assert) {
    let resolvePromise: (value: string) => void;
    const resource = new AsyncResource(
      () => new Promise((resolve) => { resolvePromise = resolve; })
    );

    const loadPromise = resource.load();

    assert.true(resource.isLoading);
    assert.false(resource.isSuccess);

    resolvePromise!('data');
    await loadPromise;

    assert.false(resource.isLoading);
    assert.true(resource.isSuccess);
  });

  test('success state with data', async function (assert) {
    const testData = { id: 1, name: 'Test' };
    const resource = new AsyncResource(() => Promise.resolve(testData));

    await resource.load();

    assert.true(resource.isSuccess);
    assert.deepEqual(resource.data, testData);
    assert.false(resource.isError);
  });

  test('error state on failure', async function (assert) {
    const resource = new AsyncResource(() =>
      Promise.reject(new Error('Failed'))
    );

    await resource.load();

    assert.true(resource.isError);
    assert.strictEqual(resource.error?.message, 'Failed');
    assert.false(resource.isSuccess);
    assert.strictEqual(resource.data, null);
  });

  test('retry resets and reloads', async function (assert) {
    let attempts = 0;
    const resource = new AsyncResource(() => {
      attempts++;
      if (attempts === 1) {
        return Promise.reject(new Error('First attempt failed'));
      }
      return Promise.resolve('success');
    });

    await resource.load();
    assert.true(resource.isError);

    await resource.retry();
    assert.true(resource.isSuccess);
    assert.strictEqual(resource.data, 'success');
    assert.strictEqual(attempts, 2);
  });

  test('cancel aborts pending request', async function (assert) {
    const resource = new AsyncResource(
      (signal: AbortSignal) =>
        new Promise((resolve, reject) => {
          const timeout = setTimeout(() => resolve('data'), 1000);
          signal.addEventListener('abort', () => {
            clearTimeout(timeout);
            reject(new DOMException('Aborted', 'AbortError'));
          });
        })
    );

    const loadPromise = resource.load();
    resource.cancel();

    await loadPromise;

    // Cancelled requests should not set error state
    assert.false(resource.isError);
    assert.false(resource.isSuccess);
    assert.false(resource.isLoading);
  });

  test('isEmpty is true when data is empty array', async function (assert) {
    const resource = new AsyncResource(() => Promise.resolve([]));

    await resource.load();

    assert.true(resource.isEmpty);
    assert.true(resource.isSuccess);
  });

  test('reset clears all state', async function (assert) {
    const resource = new AsyncResource(() => Promise.resolve('data'));

    await resource.load();
    assert.true(resource.isSuccess);

    resource.reset();

    assert.false(resource.isLoading);
    assert.false(resource.isError);
    assert.false(resource.isSuccess);
    assert.strictEqual(resource.data, null);
  });
});
