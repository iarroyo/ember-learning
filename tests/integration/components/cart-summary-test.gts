import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click } from '@ember/test-helpers';
import { CartSummary } from 'ember-learning/components/cart-summary';
import type ShoppingCartService from 'ember-learning/services/shopping-cart';

module('Integration | Component | cart-summary', function (hooks) {
  setupRenderingTest(hooks);

  test('it displays empty cart state', async function (assert) {
    await render(<template><CartSummary /></template>);

    assert.dom('[data-test-item-count]').hasText('0');
    assert.dom('[data-test-subtotal]').hasText('$0.00');
  });

  test('it displays cart with items', async function (assert) {
    const shoppingCart = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;
    shoppingCart.addItem({ id: '1', name: 'Widget', price: 10 });
    shoppingCart.addItem({ id: '2', name: 'Gadget', price: 25.5 });

    await render(<template><CartSummary /></template>);

    assert.dom('[data-test-item-count]').hasText('2');
    assert.dom('[data-test-subtotal]').hasText('$35.50');
  });

  test('clear button empties the cart', async function (assert) {
    const shoppingCart = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;
    shoppingCart.addItem({ id: '1', name: 'Widget', price: 10 });

    await render(<template><CartSummary /></template>);

    assert.dom('[data-test-item-count]').hasText('1');

    await click('[data-test-clear-cart]');

    assert.dom('[data-test-item-count]').hasText('0');
    assert.dom('[data-test-subtotal]').hasText('$0.00');
  });

  test('clear button is disabled when cart is empty', async function (assert) {
    await render(<template><CartSummary /></template>);

    assert.dom('[data-test-clear-cart]').isDisabled();
  });
});
