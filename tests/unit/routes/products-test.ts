import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import type ProductsRoute from 'ember-learning/routes/products';

module('Unit | Route | products', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    const route = this.owner.lookup('route:products') as ProductsRoute;
    assert.ok(route);
  });

  test('model hook returns all products', function (assert) {
    const route = this.owner.lookup('route:products') as ProductsRoute;
    const model = route.model();

    assert.strictEqual(model.length, 3);
    assert.strictEqual(model[0]?.name, 'Wireless Headphones');
  });
});
