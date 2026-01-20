import { module, test } from 'qunit';
import { visit, click, currentURL } from '@ember/test-helpers';
import { setupApplicationTest } from 'ember-qunit';

module('Acceptance | products', function (hooks) {
  setupApplicationTest(hooks);

  test('visiting /products shows product list', async function (assert) {
    await visit('/products');

    assert.strictEqual(currentURL(), '/products');
    assert.dom('[data-test-product-card]').exists({ count: 3 });
  });

  test('clicking a product navigates to detail page', async function (assert) {
    await visit('/products');

    await click('[data-test-product-link]:first-child');

    assert.strictEqual(currentURL(), '/products/1');
    assert.dom('[data-test-product-detail]').exists();
    assert.dom('[data-test-product-name]').hasText('Wireless Headphones');
  });

  test('back link returns to products list', async function (assert) {
    await visit('/products/1');

    await click('[data-test-back-link]');

    assert.strictEqual(currentURL(), '/products');
  });

  test('non-existent product shows 404 message', async function (assert) {
    await visit('/products/non-existent');

    assert.dom('[data-test-not-found]').exists();
    assert.dom('[data-test-not-found]').containsText('Product not found');
  });
});
