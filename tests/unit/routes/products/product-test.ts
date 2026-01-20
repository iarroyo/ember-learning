import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import type ProductsProductRoute from 'ember-learning/routes/products/product';

module('Unit | Route | products/product', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    const route = this.owner.lookup('route:products/product') as ProductsProductRoute;
    assert.ok(route);
  });

  test('model hook returns product by id', async function (assert) {
    const route = this.owner.lookup('route:products/product') as ProductsProductRoute;
    const model = await route.model({ product_id: '2' });

    assert.strictEqual(model?.name, 'Mechanical Keyboard');
    assert.strictEqual(model?.price, 149.99);
  });

  test('model hook returns null for non-existent product', async function (assert) {
    const route = this.owner.lookup('route:products/product') as ProductsProductRoute;
    const model = await route.model({ product_id: 'non-existent' });

    assert.strictEqual(model, null);
  });
});
