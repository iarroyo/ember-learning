import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import { HelloMessage } from 'ember-learning/components/hello-message';

module('Integration | Component | hello-message', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders a greeting with the provided name', async function (assert) {
    await render(
      <template>
        <HelloMessage @name="Ember" />
      </template>
    );

    assert.dom('p.greeting').exists();
    assert.dom('p.greeting').hasText('Hello, Ember!');
  });

  test('it renders default greeting when no name is provided', async function (assert) {
    await render(
      <template>
        <HelloMessage />
      </template>
    );

    assert.dom('p.greeting').hasText('Hello, World!');
  });

  test('it renders greeting with different names', async function (assert) {
    await render(
      <template>
        <HelloMessage @name="Developer" />
      </template>
    );

    assert.dom('p.greeting').hasText('Hello, Developer!');
  });

  test('it handles empty string as name', async function (assert) {
    await render(
      <template>
        <HelloMessage @name="" />
      </template>
    );

    // Empty string should fall back to default
    assert.dom('p.greeting').hasText('Hello, World!');
  });
});
