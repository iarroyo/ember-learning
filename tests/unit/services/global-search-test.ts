import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import { settled } from '@ember/test-helpers';
import type GlobalSearchService from 'ember-learning/services/global-search';

module('Unit | Service | global-search', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;
    assert.ok(service);
  });

  test('searchTask performs search and returns results', async function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;

    await service.searchTask.perform('test query');

    assert.strictEqual(service.results.length, 2);
    assert.ok(service.results[0]?.title.includes('test query'));
  });

  test('results getter returns lastSuccessful value', async function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;

    // Initially empty
    assert.deepEqual(service.results, []);

    await service.searchTask.perform('query');

    // Now has results
    assert.strictEqual(service.results.length, 2);
  });

  test('isSearching reflects task running state', async function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;

    assert.false(service.isSearching);

    // Start search but don't await
    const taskInstance = service.searchTask.perform('query');

    // Should be running
    assert.true(service.isSearching);

    await taskInstance;
    await settled();

    assert.false(service.isSearching);
  });

  test('searchHistory tracks all searches', async function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;

    assert.strictEqual(service.searchHistory.length, 0);

    await service.searchTask.perform('first');
    assert.strictEqual(service.searchHistory.length, 1);
    assert.strictEqual(service.searchHistory[0]?.query, 'first');
    assert.strictEqual(service.searchHistory[0]?.resultCount, 2);

    await service.searchTask.perform('second');
    assert.strictEqual(service.searchHistory.length, 2);
    assert.strictEqual(service.searchHistory[1]?.query, 'second');
  });

  test('lastQuery returns the most recent search query', async function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;

    assert.strictEqual(service.lastQuery, undefined);

    await service.searchTask.perform('first');
    assert.strictEqual(service.lastQuery, 'first');

    await service.searchTask.perform('second');
    assert.strictEqual(service.lastQuery, 'second');
  });

  test('cancelAllSearches cancels running task', async function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;

    // Start search but don't await
    service.searchTask.perform('query');

    assert.true(service.isSearching);

    service.cancelAllSearches();

    assert.false(service.isSearching);
  });

  test('clearHistory removes all history entries', async function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;

    await service.searchTask.perform('query1');
    await service.searchTask.perform('query2');

    assert.strictEqual(service.searchHistory.length, 2);

    service.clearHistory();

    assert.strictEqual(service.searchHistory.length, 0);
  });

  test('restartable modifier cancels previous search when new one starts', async function (assert) {
    const service = this.owner.lookup('service:global-search') as GlobalSearchService;

    // Start first search
    const task1 = service.searchTask.perform('first');

    // Immediately start second search
    const task2 = service.searchTask.perform('second');

    // First task should be cancelled
    assert.true(task1.isCanceled);

    // Wait for second to complete
    await task2;

    // Only second search should be in history (first was cancelled before completing)
    assert.strictEqual(service.searchHistory.length, 1);
    assert.strictEqual(service.searchHistory[0]?.query, 'second');
  });
});
