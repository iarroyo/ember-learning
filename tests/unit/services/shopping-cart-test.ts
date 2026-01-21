import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import type ShoppingCartService from 'ember-learning/services/shopping-cart';

module('Unit | Service | shopping-cart', function (hooks) {
  setupTest(hooks);

  test('it starts with an empty cart', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;

    assert.strictEqual(service.itemCount, 0);
    assert.strictEqual(service.subtotal, 0);
    assert.true(service.isEmpty);
    assert.strictEqual(service.items.length, 0);
  });

  test('addItem adds a new product to the cart', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;
    const product = { id: '1', name: 'Widget', price: 9.99 };

    service.addItem(product);

    assert.strictEqual(service.items.length, 1);
    assert.strictEqual(service.items[0]!.name, 'Widget');
    assert.strictEqual(service.items[0]!.quantity, 1);
    assert.strictEqual(service.itemCount, 1);
  });

  test('addItem increments quantity for existing product', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;
    const product = { id: '1', name: 'Widget', price: 9.99 };

    service.addItem(product);
    service.addItem(product);
    service.addItem(product);

    assert.strictEqual(service.items.length, 1);
    assert.strictEqual(service.items[0]!.quantity, 3);
    assert.strictEqual(service.itemCount, 3);
  });

  test('addItem handles multiple different products', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;

    service.addItem({ id: '1', name: 'Widget', price: 9.99 });
    service.addItem({ id: '2', name: 'Gadget', price: 19.99 });
    service.addItem({ id: '1', name: 'Widget', price: 9.99 });

    assert.strictEqual(service.items.length, 2);
    assert.strictEqual(service.itemCount, 3);
  });

  test('removeItem removes product from cart', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;

    service.addItem({ id: '1', name: 'Widget', price: 9.99 });
    service.addItem({ id: '2', name: 'Gadget', price: 19.99 });

    service.removeItem('1');

    assert.strictEqual(service.items.length, 1);
    assert.strictEqual(service.items[0]!.id, '2');
  });

  test('updateQuantity changes item quantity', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;

    service.addItem({ id: '1', name: 'Widget', price: 9.99 });
    service.updateQuantity('1', 5);

    assert.strictEqual(service.items[0]!.quantity, 5);
    assert.strictEqual(service.itemCount, 5);
  });

  test('updateQuantity removes item when quantity is 0 or less', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;

    service.addItem({ id: '1', name: 'Widget', price: 9.99 });
    service.updateQuantity('1', 0);

    assert.strictEqual(service.items.length, 0);
    assert.true(service.isEmpty);
  });

  test('clearCart removes all items', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;

    service.addItem({ id: '1', name: 'Widget', price: 9.99 });
    service.addItem({ id: '2', name: 'Gadget', price: 19.99 });

    service.clearCart();

    assert.strictEqual(service.items.length, 0);
    assert.true(service.isEmpty);
    assert.strictEqual(service.itemCount, 0);
  });

  test('subtotal calculates correct total', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;

    service.addItem({ id: '1', name: 'Widget', price: 10 });
    service.addItem({ id: '2', name: 'Gadget', price: 20 });
    service.addItem({ id: '1', name: 'Widget', price: 10 }); // quantity: 2

    // 10 * 2 + 20 * 1 = 40
    assert.strictEqual(service.subtotal, 40);
  });

  test('isEmpty returns correct boolean', function (assert) {
    const service = this.owner.lookup(
      'service:shopping-cart'
    ) as ShoppingCartService;

    assert.true(service.isEmpty);

    service.addItem({ id: '1', name: 'Widget', price: 9.99 });
    assert.false(service.isEmpty);

    service.clearCart();
    assert.true(service.isEmpty);
  });
});
