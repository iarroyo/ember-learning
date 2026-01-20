import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click } from '@ember/test-helpers';
import { NestedReactivity } from 'ember-learning/components/nested-reactivity';
import { NaiveList } from 'ember-learning/components/nested-reactivity/naive-list';
import { OptimizedList } from 'ember-learning/components/nested-reactivity/optimized-list';
import { resetRenderCounts } from 'ember-learning/components/nested-reactivity/render-tracked-item';

module('Integration | Component | nested-reactivity', function (hooks) {
  setupRenderingTest(hooks);

  // Reset render counts before each test
  hooks.beforeEach(function () {
    resetRenderCounts();
  });

  module('Main Component', function () {
    test('it renders both lists side by side', async function (assert) {
      await render(<template><NestedReactivity /></template>);

      assert.dom('[data-test-nested-reactivity]').exists();
      assert.dom('[data-test-naive-list]').exists();
      assert.dom('[data-test-optimized-list]').exists();
    });
  });

  module('NaiveList - demonstrates the re-render problem', function () {
    test('it renders with empty list initially', async function (assert) {
      await render(<template><NaiveList /></template>);

      assert.dom('[data-test-naive-list]').exists();
      assert.dom('[data-test-naive-add-button]').exists();
      assert.dom('[data-test-naive-item]').doesNotExist();
    });

    test('adding items causes ALL items to re-render', async function (assert) {
      await render(<template><NaiveList /></template>);

      // Add first item
      await click('[data-test-naive-add-button]');
      assert.dom('[data-test-naive-item]').exists({ count: 1 });

      const firstItemRenderCount = this.element.querySelector(
        '[data-test-naive-item] [data-test-naive-render-count]'
      );
      assert.strictEqual(
        firstItemRenderCount?.textContent?.trim(),
        '1',
        'First item rendered once'
      );

      // Add second item - first item should re-render
      await click('[data-test-naive-add-button]');
      assert.dom('[data-test-naive-item]').exists({ count: 2 });

      const allItems = this.element.querySelectorAll('[data-test-naive-item]');
      const firstItemCount = allItems[0]?.querySelector(
        '[data-test-naive-render-count]'
      )?.textContent?.trim();
      const secondItemCount = allItems[1]?.querySelector(
        '[data-test-naive-render-count]'
      )?.textContent?.trim();

      assert.strictEqual(
        firstItemCount,
        '2',
        'First item re-rendered (count increased to 2)'
      );
      assert.strictEqual(secondItemCount, '1', 'Second item rendered once');

      // Add third item - all previous items should re-render
      await click('[data-test-naive-add-button]');
      assert.dom('[data-test-naive-item]').exists({ count: 3 });

      const allItemsAfterThird =
        this.element.querySelectorAll('[data-test-naive-item]');
      const firstCount = allItemsAfterThird[0]?.querySelector(
        '[data-test-naive-render-count]'
      )?.textContent?.trim();
      const secondCount = allItemsAfterThird[1]?.querySelector(
        '[data-test-naive-render-count]'
      )?.textContent?.trim();
      const thirdCount = allItemsAfterThird[2]?.querySelector(
        '[data-test-naive-render-count]'
      )?.textContent?.trim();

      assert.strictEqual(
        firstCount,
        '3',
        'First item re-rendered again (count increased to 3)'
      );
      assert.strictEqual(
        secondCount,
        '2',
        'Second item re-rendered (count increased to 2)'
      );
      assert.strictEqual(thirdCount, '1', 'Third item rendered once');
    });
  });

  module('OptimizedList - demonstrates proper reactivity', function () {
    test('it renders with empty list initially', async function (assert) {
      await render(<template><OptimizedList /></template>);

      assert.dom('[data-test-optimized-list]').exists();
      assert.dom('[data-test-optimized-add-button]').exists();
      assert.dom('[data-test-optimized-item]').doesNotExist();
    });

    test('adding items only renders NEW items, not existing ones', async function (assert) {
      await render(<template><OptimizedList /></template>);

      // Add first item
      await click('[data-test-optimized-add-button]');
      assert.dom('[data-test-optimized-item]').exists({ count: 1 });

      const firstItemRenderCount = this.element.querySelector(
        '[data-test-optimized-item] [data-test-optimized-render-count]'
      );
      assert.strictEqual(
        firstItemRenderCount?.textContent?.trim(),
        '1',
        'First item rendered once'
      );

      // Add second item - first item should NOT re-render
      await click('[data-test-optimized-add-button]');
      assert.dom('[data-test-optimized-item]').exists({ count: 2 });

      const allItems = this.element.querySelectorAll(
        '[data-test-optimized-item]'
      );
      const firstItemCount = allItems[0]?.querySelector(
        '[data-test-optimized-render-count]'
      )?.textContent?.trim();
      const secondItemCount = allItems[1]?.querySelector(
        '[data-test-optimized-render-count]'
      )?.textContent?.trim();

      assert.strictEqual(
        firstItemCount,
        '1',
        'First item still shows render count of 1 (not re-rendered)'
      );
      assert.strictEqual(secondItemCount, '1', 'Second item rendered once');

      // Add third item - previous items should NOT re-render
      await click('[data-test-optimized-add-button]');
      assert.dom('[data-test-optimized-item]').exists({ count: 3 });

      const allItemsAfterThird = this.element.querySelectorAll(
        '[data-test-optimized-item]'
      );
      const firstCount = allItemsAfterThird[0]?.querySelector(
        '[data-test-optimized-render-count]'
      )?.textContent?.trim();
      const secondCount = allItemsAfterThird[1]?.querySelector(
        '[data-test-optimized-render-count]'
      )?.textContent?.trim();
      const thirdCount = allItemsAfterThird[2]?.querySelector(
        '[data-test-optimized-render-count]'
      )?.textContent?.trim();

      assert.strictEqual(
        firstCount,
        '1',
        'First item still shows render count of 1'
      );
      assert.strictEqual(
        secondCount,
        '1',
        'Second item still shows render count of 1'
      );
      assert.strictEqual(thirdCount, '1', 'Third item rendered once');
    });
  });

  module('Comparison', function () {
    test('naive list has higher render counts than optimized after multiple adds', async function (assert) {
      await render(<template><NestedReactivity /></template>);

      // Add 3 items to both lists
      await click('[data-test-naive-add-button]');
      await click('[data-test-optimized-add-button]');

      await click('[data-test-naive-add-button]');
      await click('[data-test-optimized-add-button]');

      await click('[data-test-naive-add-button]');
      await click('[data-test-optimized-add-button]');

      // Check naive list - first item should have render count of 3
      const naiveItems = this.element.querySelectorAll('[data-test-naive-item]');
      const naiveFirstCount = naiveItems[0]?.querySelector(
        '[data-test-naive-render-count]'
      )?.textContent?.trim();
      assert.strictEqual(
        naiveFirstCount,
        '3',
        'Naive: first item rendered 3 times'
      );

      // Check optimized list - first item should still have render count of 1
      const optimizedItems = this.element.querySelectorAll(
        '[data-test-optimized-item]'
      );
      const optimizedFirstCount = optimizedItems[0]?.querySelector(
        '[data-test-optimized-render-count]'
      )?.textContent?.trim();
      assert.strictEqual(
        optimizedFirstCount,
        '1',
        'Optimized: first item rendered only once'
      );
    });
  });
});
