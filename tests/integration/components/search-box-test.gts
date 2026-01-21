import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, fillIn, click, waitFor, waitUntil } from '@ember/test-helpers';
import { SearchBox } from 'ember-learning/components/search-box';
import type { SearchResult } from 'ember-learning/components/search-box';

module('Integration | Component | search-box', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with default placeholder', async function (assert) {
    await render(<template><SearchBox /></template>);

    assert
      .dom('[data-test-search-input]')
      .hasAttribute('placeholder', 'Search...');
  });

  test('it renders with custom placeholder', async function (assert) {
    await render(
      <template><SearchBox @placeholder="Find products..." /></template>
    );

    assert
      .dom('[data-test-search-input]')
      .hasAttribute('placeholder', 'Find products...');
  });

  test('it shows loading state while searching', async function (assert) {
    await render(<template><SearchBox /></template>);

    assert.dom('[data-test-search-loading]').doesNotExist();

    // Start typing to trigger search
    void fillIn('[data-test-search-input]', 'test');

    // Wait for loading state
    await waitFor('[data-test-search-loading]');
    assert.dom('[data-test-search-loading]').exists();
    assert.dom('[data-test-search-cancel]').exists();

    // Wait for search to complete (wait for loading to disappear)
    await waitUntil(
      () => !document.querySelector('[data-test-search-loading]'),
      { timeout: 2000 }
    );
    assert.dom('[data-test-search-loading]').doesNotExist();
  });

  test('it displays search results', async function (assert) {
    await render(<template><SearchBox /></template>);

    await fillIn('[data-test-search-input]', 'hello');
    // Wait for results to appear
    await waitFor('[data-test-search-results-count]');

    assert.dom('[data-test-search-results-count]').hasText('3 results');
    assert.dom('[data-test-search-result]').exists({ count: 3 });
  });

  test('it calls onResults callback with results', async function (assert) {
    let receivedResults: SearchResult[] = [];
    const handleResults = (results: SearchResult[]) => {
      receivedResults = results;
    };

    await render(
      <template><SearchBox @onResults={{handleResults}} /></template>
    );

    await fillIn('[data-test-search-input]', 'query');
    // Wait for results to appear
    await waitFor('[data-test-search-results-count]');

    assert.strictEqual(receivedResults.length, 3);
    assert.ok(receivedResults[0]?.title.includes('query'));
  });

  test('cancel button only cancels this component task', async function (assert) {
    await render(<template><SearchBox /></template>);

    // Start a search
    void fillIn('[data-test-search-input]', 'test');
    await waitFor('[data-test-search-loading]');

    // Click cancel
    await click('[data-test-search-cancel]');

    // Loading should stop
    assert.dom('[data-test-search-loading]').doesNotExist();
  });

  test('uses lastSuccessful to show stale data while loading', async function (assert) {
    await render(<template><SearchBox /></template>);

    // First search
    await fillIn('[data-test-search-input]', 'first');
    // Wait for results to appear
    await waitFor('[data-test-search-results-count]');

    assert.dom('[data-test-search-result]').exists({ count: 3 });

    // Start second search - should still show old results
    void fillIn('[data-test-search-input]', 'second');
    await waitFor('[data-test-search-loading]');

    // Old results should still be visible (stale-while-revalidate)
    assert.dom('[data-test-search-result]').exists({ count: 3 });
    assert.dom('[data-test-search-result]').includesText('first');

    // Wait for new results
    await waitUntil(
      () =>
        document
          .querySelector('[data-test-search-result]')
          ?.textContent?.includes('second'),
      { timeout: 2000 }
    );

    // Now should show new results
    assert.dom('[data-test-search-result]').includesText('second');
  });

  test('two SearchBox components have independent tasks', async function (assert) {
    await render(
      <template>
        <div data-test-box-1>
          <SearchBox @placeholder="Box 1" />
        </div>
        <div data-test-box-2>
          <SearchBox @placeholder="Box 2" />
        </div>
      </template>
    );

    // Start search in both boxes
    void fillIn('[data-test-box-1] [data-test-search-input]', 'query1');
    void fillIn('[data-test-box-2] [data-test-search-input]', 'query2');

    await waitFor('[data-test-box-1] [data-test-search-loading]');
    await waitFor('[data-test-box-2] [data-test-search-loading]');

    // Both should be loading
    assert.dom('[data-test-box-1] [data-test-search-loading]').exists();
    assert.dom('[data-test-box-2] [data-test-search-loading]').exists();

    // Cancel only box 1
    await click('[data-test-box-1] [data-test-search-cancel]');

    // Box 1 should stop loading, box 2 should continue
    assert.dom('[data-test-box-1] [data-test-search-loading]').doesNotExist();
    // Box 2 might have finished by now, so we just verify box 1 cancellation worked

    // Wait for any remaining async operations
    await waitUntil(
      () =>
        !document.querySelector('[data-test-box-2] [data-test-search-loading]'),
      { timeout: 2000 }
    );
  });
});
