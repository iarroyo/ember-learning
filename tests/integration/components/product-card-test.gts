import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click } from '@ember/test-helpers';
import { ProductCard } from 'ember-learning/components/product-card';
import type ShoppingCartService from 'ember-learning/services/shopping-cart';

module('Integration | Component | product-card', function (hooks) {
  setupRenderingTest(hooks);

  test('it displays product information', async function (assert) {
    const product = {
      id: '1',
      name: 'Test Product',
      price: 99.99,
      image: '/test.jpg'
    };

    await render(
      <template>
        <ProductCard @product={{product}} />
      </template>
    );

    assert.dom('[data-test-product-name]').hasText('Test Product');
    assert.dom('[data-test-product-price]').hasText('$99.99');
    assert.dom('[data-test-product-image]').hasAttribute('src', '/test.jpg');
  });

  test('it links to product detail page', async function (assert) {
    const product = {
      id: '42',
      name: 'Test Product',
      price: 99.99
    };

    await render(
      <template>
        <ProductCard @product={{product}} />
      </template>
    );

    assert.dom('[data-test-product-link]').hasAttribute('href', '/products/42');
  });

  test('add to cart button calls shopping cart service', async function (assert) {
    const shoppingCart = this.owner.lookup('service:shopping-cart') as ShoppingCartService;
    const product = {
      id: '1',
      name: 'Test Product',
      price: 99.99
    };

    await render(
      <template>
        <ProductCard @product={{product}} />
      </template>
    );

    assert.strictEqual(shoppingCart.itemCount, 0);

    await click('[data-test-add-to-cart]');

    assert.strictEqual(shoppingCart.itemCount, 1);
    assert.strictEqual(shoppingCart.items[0]!.name, 'Test Product');
  });
});
