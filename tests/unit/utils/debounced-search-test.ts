import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import { settled } from '@ember/test-helpers';
import { DebouncedSearch } from 'ember-learning/utils/debounced-search';

module('Unit | Utility | debounced-search', function (hooks) {
  setupTest(hooks);

  test('it calls callback after delay', async function (assert) {
    const search = new DebouncedSearch();
    let searchedQuery = '';

    search.search(
      'hello',
      async (query) => {
        searchedQuery = query;
        await Promise.resolve();
      },
      50
    );

    assert.strictEqual(searchedQuery, '', 'callback not called immediately');

    // settled() waits for buildWaiter to complete
    await settled();

    assert.strictEqual(searchedQuery, 'hello', 'callback called with query');
  });

  test('it cancels previous search when new search is initiated', async function (assert) {
    const search = new DebouncedSearch();
    const calls: string[] = [];

    search.search(
      'first',
      async (query) => {
        calls.push(query);
        await Promise.resolve();
      },
      50
    );

    // Immediately start another search
    search.search(
      'second',
      async (query) => {
        calls.push(query);
        await Promise.resolve();
      },
      50
    );

    await settled();

    assert.deepEqual(calls, ['second'], 'only second search was executed');
  });

  test('cancel() stops pending search', async function (assert) {
    const search = new DebouncedSearch();
    let called = false;

    search.search(
      'query',
      async () => {
        called = true;
        await Promise.resolve();
      },
      50
    );

    assert.true(search.isPending, 'search is pending');

    search.cancel();

    assert.false(search.isPending, 'search is no longer pending');

    await settled();

    assert.false(called, 'callback was not called');
  });

  test('isPending reflects search state', async function (assert) {
    const search = new DebouncedSearch();

    assert.false(search.isPending, 'initially not pending');

    search.search(
      'query',
      async () => {
        await Promise.resolve();
      },
      50
    );

    assert.true(search.isPending, 'pending after search called');

    await settled();

    assert.false(search.isPending, 'not pending after completion');
  });

  test('multiple rapid searches only execute the last one', async function (assert) {
    const search = new DebouncedSearch();
    const calls: string[] = [];

    for (let i = 1; i <= 5; i++) {
      search.search(
        `query${i}`,
        async (query) => {
          calls.push(query);
          await Promise.resolve();
        },
        50
      );
    }

    await settled();

    assert.deepEqual(calls, ['query5'], 'only last search executed');
  });

  test('waiter ensures tests wait for async callback', async function (assert) {
    const search = new DebouncedSearch();
    let asyncCompleted = false;

    search.search(
      'query',
      async () => {
        // Simulate async work
        await new Promise((r) => setTimeout(r, 20));
        asyncCompleted = true;
      },
      10
    );

    // settled() will wait for both the debounce timeout AND the async callback
    await settled();

    assert.true(
      asyncCompleted,
      'async callback completed before settled() returned'
    );
  });
});
