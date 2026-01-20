import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, fillIn, click, waitFor, waitUntil } from '@ember/test-helpers';
import { GlobalSearchBox } from 'ember-learning/components/global-search-box';
import type GlobalSearchService from 'ember-learning/services/global-search';

module('Integration | Component | global-search-box', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with default placeholder', async function (assert) {
    await render(
      <template>
        <GlobalSearchBox />
      </template>
    );

    assert.dom('[data-test-search-input]').hasAttribute('placeholder', 'Global search...');
  });

  test('it renders with custom placeholder', async function (assert) {
    await render(
      <template>
        <GlobalSearchBox @placeholder="Search everywhere..." />
      </template>
    );

    assert.dom('[data-test-search-input]').hasAttribute('placeholder', 'Search everywhere...');
  });

  test('it shows loading state while searching', async function (assert) {
    await render(
      <template>
        <GlobalSearchBox />
      </template>
    );

    fillIn('[data-test-search-input]', 'test');
    await waitFor('[data-test-search-loading]');

    assert.dom('[data-test-search-loading]').exists();
    assert.dom('[data-test-search-cancel]').exists();

    // Wait for search to complete
    await waitUntil(() => !document.querySelector('[data-test-search-loading]'), { timeout: 2000 });
  });

  test('it displays search results from service', async function (assert) {
    await render(
      <template>
        <GlobalSearchBox />
      </template>
    );

    await fillIn('[data-test-search-input]', 'hello');
    // Wait for results to appear
    await waitFor('[data-test-search-results-count]');

    assert.dom('[data-test-search-results-count]').hasText('2 results');
    assert.dom('[data-test-search-result]').exists({ count: 2 });
  });

  test('it tracks search history', async function (assert) {
    await render(
      <template>
        <GlobalSearchBox />
      </template>
    );

    // First search
    await fillIn('[data-test-search-input]', 'first query');
    // Wait for results and history to appear
    await waitFor('[data-test-history-entry]');

    assert.dom('[data-test-history-entry]').exists({ count: 1 });
    assert.dom('[data-test-history-entry]').includesText('first query');

    // Second search
    await fillIn('[data-test-search-input]', 'second query');
    // Wait for second history entry
    await waitUntil(() => document.querySelectorAll('[data-test-history-entry]').length === 2, { timeout: 2000 });

    assert.dom('[data-test-history-entry]').exists({ count: 2 });
  });

  test('clear history removes all entries', async function (assert) {
    await render(
      <template>
        <GlobalSearchBox />
      </template>
    );

    await fillIn('[data-test-search-input]', 'query');
    // Wait for history entry to appear
    await waitFor('[data-test-history-entry]');

    assert.dom('[data-test-history-entry]').exists({ count: 1 });

    await click('[data-test-clear-history]');

    assert.dom('[data-test-history-entry]').doesNotExist();
    assert.dom('[data-test-history-label]').doesNotExist();
  });

  test('two GlobalSearchBox components share the same task', async function (assert) {
    await render(
      <template>
        <div data-test-box-1>
          <GlobalSearchBox @placeholder="Box 1" />
        </div>
        <div data-test-box-2>
          <GlobalSearchBox @placeholder="Box 2" />
        </div>
      </template>
    );

    // Search from box 1
    await fillIn('[data-test-box-1] [data-test-search-input]', 'shared query');
    // Wait for results to appear
    await waitFor('[data-test-box-1] [data-test-search-results-count]');

    // Both boxes should show the same results (from shared service)
    assert.dom('[data-test-box-1] [data-test-search-result]').exists({ count: 2 });
    assert.dom('[data-test-box-2] [data-test-search-result]').exists({ count: 2 });

    // Both should share the same history
    assert.dom('[data-test-box-1] [data-test-history-entry]').exists({ count: 1 });
    assert.dom('[data-test-box-2] [data-test-history-entry]').exists({ count: 1 });
  });

  test('cancelling from one box cancels for all boxes (shared task)', async function (assert) {
    await render(
      <template>
        <div data-test-box-1>
          <GlobalSearchBox @placeholder="Box 1" />
        </div>
        <div data-test-box-2>
          <GlobalSearchBox @placeholder="Box 2" />
        </div>
      </template>
    );

    // Start search from box 1
    fillIn('[data-test-box-1] [data-test-search-input]', 'test');
    await waitFor('[data-test-box-1] [data-test-search-loading]');

    // Both should show loading (shared task)
    assert.dom('[data-test-box-1] [data-test-search-loading]').exists();
    assert.dom('[data-test-box-2] [data-test-search-loading]').exists();

    // Cancel from box 2 (should cancel for both since task is shared)
    await click('[data-test-box-2] [data-test-search-cancel]');

    // Both should stop loading
    assert.dom('[data-test-box-1] [data-test-search-loading]').doesNotExist();
    assert.dom('[data-test-box-2] [data-test-search-loading]').doesNotExist();
  });

  test('service state persists across component renders', async function (assert) {
    const globalSearch = this.owner.lookup('service:global-search') as GlobalSearchService;

    // Pre-populate some history
    await globalSearch.searchTask.perform('pre-existing');

    await render(
      <template>
        <GlobalSearchBox />
      </template>
    );

    // Should show pre-existing history
    assert.dom('[data-test-history-entry]').exists({ count: 1 });
    assert.dom('[data-test-history-entry]').includesText('pre-existing');

    // Should show pre-existing results
    assert.dom('[data-test-search-result]').exists({ count: 2 });
  });
});
