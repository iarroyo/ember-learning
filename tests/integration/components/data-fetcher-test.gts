import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click, waitFor } from '@ember/test-helpers';
import { on } from '@ember/modifier';
import { DataFetcher } from 'ember-learning/components/data-fetcher';

module('Integration | Component | data-fetcher', function (hooks) {
  setupRenderingTest(hooks);

  test('renders loading state initially', async function (assert) {
    const fetchFn = () => new Promise(() => {}); // Never resolves

    render(
      <template>
        <DataFetcher @fetch={{fetchFn}} as |resource|>
          {{#if resource.isLoading}}
            <div data-test-loading>Loading...</div>
          {{/if}}
        </DataFetcher>
      </template>
    );

    await waitFor('[data-test-loading]');
    assert.dom('[data-test-loading]').exists();
  });

  test('renders data on success', async function (assert) {
    const fetchFn = () => Promise.resolve({ name: 'Test User' });

    await render(
      <template>
        <DataFetcher @fetch={{fetchFn}} as |resource|>
          {{#if resource.isSuccess}}
            <div data-test-data>{{resource.data.name}}</div>
          {{/if}}
        </DataFetcher>
      </template>
    );

    assert.dom('[data-test-data]').hasText('Test User');
  });

  test('renders error state with retry', async function (assert) {
    let attempts = 0;
    const fetchFn = () => {
      attempts++;
      if (attempts === 1) {
        return Promise.reject(new Error('Failed'));
      }
      return Promise.resolve({ name: 'Success' });
    };

    await render(
      <template>
        <DataFetcher @fetch={{fetchFn}} as |resource|>
          {{#if resource.isError}}
            <div data-test-error>{{resource.error.message}}</div>
            <button data-test-retry type="button" {{on "click" resource.retry}}>
              Retry
            </button>
          {{/if}}
          {{#if resource.isSuccess}}
            <div data-test-success>{{resource.data.name}}</div>
          {{/if}}
        </DataFetcher>
      </template>
    );

    assert.dom('[data-test-error]').hasText('Failed');

    await click('[data-test-retry]');

    assert.dom('[data-test-success]').hasText('Success');
  });

  test('renders empty state', async function (assert) {
    const fetchFn = () => Promise.resolve([]);

    await render(
      <template>
        <DataFetcher @fetch={{fetchFn}} as |resource|>
          {{#if resource.isEmpty}}
            <div data-test-empty>No items found</div>
          {{/if}}
        </DataFetcher>
      </template>
    );

    assert.dom('[data-test-empty]').exists();
  });

  test('auto-refresh reloads data at interval', async function (assert) {
    let callCount = 0;
    const fetchFn = () => {
      callCount++;
      return Promise.resolve({ count: callCount });
    };

    await render(
      <template>
        <DataFetcher @fetch={{fetchFn}} @refreshInterval={{100}} as |resource|>
          {{#if resource.isSuccess}}
            <div data-test-count>{{resource.data.count}}</div>
          {{/if}}
        </DataFetcher>
      </template>
    );

    assert.dom('[data-test-count]').hasText('1');

    // Wait for auto-refresh
    await new Promise(resolve => setTimeout(resolve, 150));

    assert.dom('[data-test-count]').hasText('2');
  });
});
