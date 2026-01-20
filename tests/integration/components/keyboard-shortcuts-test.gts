import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, triggerKeyEvent, settled, clearRender } from '@ember/test-helpers';
import { KeyboardShortcuts, onKeydown } from 'ember-learning/components/keyboard-shortcuts';
import { tracked } from '@glimmer/tracking';

module('Integration | Component | keyboard-shortcuts', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders and yields content', async function (assert) {
    const shortcuts = new Map<string, () => void>();

    await render(
      <template>
        <KeyboardShortcuts @shortcuts={{shortcuts}}>
          <span data-test-content>Content</span>
        </KeyboardShortcuts>
      </template>
    );

    assert.dom('[data-test-keyboard-shortcuts]').exists();
    assert.dom('[data-test-content]').hasText('Content');
  });

  test('global shortcuts respond to keydown events', async function (assert) {
    let escapeCalled = false;
    let arrowUpCalled = false;

    const shortcuts = new Map<string, () => void>([
      ['Escape', () => { escapeCalled = true; }],
      ['ArrowUp', () => { arrowUpCalled = true; }],
    ]);

    await render(
      <template>
        <KeyboardShortcuts @shortcuts={{shortcuts}}>
          <span>Content</span>
        </KeyboardShortcuts>
      </template>
    );

    await triggerKeyEvent(document.body, 'keydown', 'Escape');
    assert.true(escapeCalled, 'Escape shortcut was triggered');

    await triggerKeyEvent(document.body, 'keydown', 'ArrowUp');
    assert.true(arrowUpCalled, 'ArrowUp shortcut was triggered');
  });

  test('global shortcuts are cleaned up on destroy', async function (assert) {
    let callCount = 0;

    const shortcuts = new Map<string, () => void>([
      ['Delete', () => { callCount++; }],
    ]);

    await render(
      <template>
        <KeyboardShortcuts @shortcuts={{shortcuts}}>
          <span>Content</span>
        </KeyboardShortcuts>
      </template>
    );

    await triggerKeyEvent(document.body, 'keydown', 'Delete');
    assert.strictEqual(callCount, 1, 'shortcut triggered once');

    // Destroy the component
    await clearRender();

    // Trigger key again - should not call handler
    await triggerKeyEvent(document.body, 'keydown', 'Delete');
    assert.strictEqual(callCount, 1, 'shortcut not triggered after destroy');
  });

  test('onKeydown modifier responds to element keydown', async function (assert) {
    let enterCalled = false;
    const handleEnter = () => { enterCalled = true; };
    const shortcuts = new Map<string, () => void>();

    await render(
      <template>
        <KeyboardShortcuts @shortcuts={{shortcuts}}>
          <input
            data-test-input
            {{onKeydown "Enter" handleEnter}}
          />
        </KeyboardShortcuts>
      </template>
    );

    await triggerKeyEvent('[data-test-input]', 'keydown', 'Enter');
    assert.true(enterCalled, 'Enter handler was called');
  });

  test('onKeydown modifier cleans up on element removal', async function (assert) {
    let callCount = 0;
    const handleEnter = () => { callCount++; };
    const shortcuts = new Map<string, () => void>();

    class State {
      @tracked showInput = true;
    }
    const state = new State();

    await render(
      <template>
        <KeyboardShortcuts @shortcuts={{shortcuts}}>
          {{#if state.showInput}}
            <input
              data-test-input
              {{onKeydown "Enter" handleEnter}}
            />
          {{/if}}
        </KeyboardShortcuts>
      </template>
    );

    await triggerKeyEvent('[data-test-input]', 'keydown', 'Enter');
    assert.strictEqual(callCount, 1, 'handler called once');

    // Remove the input
    state.showInput = false;
    await settled();

    assert.dom('[data-test-input]').doesNotExist();
    // Listener should be cleaned up - no way to verify directly,
    // but no errors should occur
  });

  test('onInit is called and isDestroying prevents state update', async function (assert) {
    let initStarted = false;
    let initResolved = false;
    let resolveInit: () => void;

    const onInit = () => {
      initStarted = true;
      return new Promise<void>((resolve) => {
        resolveInit = () => {
          initResolved = true;
          resolve();
        };
      });
    };

    const shortcuts = new Map<string, () => void>();

    await render(
      <template>
        <KeyboardShortcuts @shortcuts={{shortcuts}} @onInit={{onInit}}>
          <span>Content</span>
        </KeyboardShortcuts>
      </template>
    );

    assert.true(initStarted, 'onInit was called');
    assert.false(initResolved, 'onInit not yet resolved');

    // Destroy before resolving
    await clearRender();

    // Resolve the promise after destroy
    resolveInit!();
    await settled();

    // Component was destroyed, isDestroying check should prevent errors
    assert.true(initResolved, 'onInit resolved');
    // No error thrown means isDestroying check worked
    assert.ok(true, 'no error from updating destroyed component');
  });

  test('spreads attributes to container', async function (assert) {
    const shortcuts = new Map<string, () => void>();

    await render(
      <template>
        <KeyboardShortcuts @shortcuts={{shortcuts}} class="custom-class" data-custom="test">
          <span>Content</span>
        </KeyboardShortcuts>
      </template>
    );

    assert.dom('[data-test-keyboard-shortcuts]').hasClass('custom-class');
    assert.dom('[data-test-keyboard-shortcuts]').hasAttribute('data-custom', 'test');
  });
});
