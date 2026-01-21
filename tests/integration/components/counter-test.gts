import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click } from '@ember/test-helpers';
import { Counter } from 'ember-learning/components/counter';

module('Integration | Component | counter', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with initial count of 0', async function (assert) {
    await render(<template><Counter /></template>);

    assert.dom('[data-test-count]').hasText('0');
  });

  test('it renders with custom initial value', async function (assert) {
    await render(<template><Counter @initialValue={{10}} /></template>);

    assert.dom('[data-test-count]').hasText('10');
  });

  test('increment button increases count by 1', async function (assert) {
    await render(<template><Counter /></template>);

    assert.dom('[data-test-count]').hasText('0');

    await click('[data-test-increment]');
    assert.dom('[data-test-count]').hasText('1');

    await click('[data-test-increment]');
    assert.dom('[data-test-count]').hasText('2');
  });

  test('decrement button decreases count by 1', async function (assert) {
    await render(<template><Counter @initialValue={{5}} /></template>);

    assert.dom('[data-test-count]').hasText('5');

    await click('[data-test-decrement]');
    assert.dom('[data-test-count]').hasText('4');

    await click('[data-test-decrement]');
    assert.dom('[data-test-count]').hasText('3');
  });

  test('reset button sets count back to initial value', async function (assert) {
    await render(<template><Counter @initialValue={{5}} /></template>);

    await click('[data-test-increment]');
    await click('[data-test-increment]');
    assert.dom('[data-test-count]').hasText('7');

    await click('[data-test-reset]');
    assert.dom('[data-test-count]').hasText('5');
  });

  test('reset with no initial value resets to 0', async function (assert) {
    await render(<template><Counter /></template>);

    await click('[data-test-increment]');
    await click('[data-test-increment]');
    await click('[data-test-increment]');
    assert.dom('[data-test-count]').hasText('3');

    await click('[data-test-reset]');
    assert.dom('[data-test-count]').hasText('0');
  });

  test('count can go negative', async function (assert) {
    await render(<template><Counter /></template>);

    await click('[data-test-decrement]');
    assert.dom('[data-test-count]').hasText('-1');

    await click('[data-test-decrement]');
    assert.dom('[data-test-count]').hasText('-2');
  });
});
