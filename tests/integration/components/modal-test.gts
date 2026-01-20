import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, click, triggerKeyEvent, waitFor } from '@ember/test-helpers';
import { on } from '@ember/modifier';
import { Modal } from 'ember-learning/components/modal';

module('Integration | Component | modal', function (hooks) {
  setupRenderingTest(hooks);

  test('renders trigger button', async function (assert) {
    await render(
      <template>
        <Modal as |modal|>
          <modal.Trigger data-test-trigger>
            Open
          </modal.Trigger>
        </Modal>
      </template>
    );

    assert.dom('[data-test-trigger]').exists();
    assert.dom('[data-test-trigger]').hasText('Open');
    assert.dom('[data-test-modal]').doesNotExist();
  });

  test('opens modal when trigger is clicked', async function (assert) {
    await render(
      <template>
        <Modal as |modal|>
          <modal.Trigger data-test-trigger>Open</modal.Trigger>
          <modal.Body>
            <p data-test-content>Modal content</p>
          </modal.Body>
        </Modal>
      </template>
    );

    await click('[data-test-trigger]');

    assert.dom('[data-test-modal]').exists();
    assert.dom('[data-test-content]').hasText('Modal content');
  });

  test('closes modal when close button is clicked', async function (assert) {
    await render(
      <template>
        <Modal as |modal|>
          <modal.Trigger data-test-trigger>Open</modal.Trigger>
          <modal.Header @title="Test Modal" />
          <modal.Body>Content</modal.Body>
        </Modal>
      </template>
    );

    await click('[data-test-trigger]');
    assert.dom('[data-test-modal]').exists();

    await click('[data-test-modal-close]');
    await waitFor('[data-test-modal]', { count: 0 });

    assert.dom('[data-test-modal]').doesNotExist();
  });

  test('closes modal when Escape key is pressed', async function (assert) {
    await render(
      <template>
        <Modal as |modal|>
          <modal.Trigger data-test-trigger>Open</modal.Trigger>
          <modal.Body>Content</modal.Body>
        </Modal>
      </template>
    );

    await click('[data-test-trigger]');
    assert.dom('[data-test-modal]').exists();

    await triggerKeyEvent('[data-test-modal]', 'keydown', 'Escape');
    await waitFor('[data-test-modal]', { count: 0 });

    assert.dom('[data-test-modal]').doesNotExist();
  });

  test('closes modal when backdrop is clicked', async function (assert) {
    await render(
      <template>
        <Modal @closeOnBackdropClick={{true}} as |modal|>
          <modal.Trigger data-test-trigger>Open</modal.Trigger>
          <modal.Body>Content</modal.Body>
        </Modal>
      </template>
    );

    await click('[data-test-trigger]');
    assert.dom('[data-test-modal]').exists();

    await click('[data-test-modal-backdrop]');
    await waitFor('[data-test-modal]', { count: 0 });

    assert.dom('[data-test-modal]').doesNotExist();
  });

  test('does not close when closeOnBackdropClick is false', async function (assert) {
    await render(
      <template>
        <Modal @closeOnBackdropClick={{false}} as |modal|>
          <modal.Trigger data-test-trigger>Open</modal.Trigger>
          <modal.Body>Content</modal.Body>
        </Modal>
      </template>
    );

    await click('[data-test-trigger]');
    await click('[data-test-modal-backdrop]');

    assert.dom('[data-test-modal]').exists();
  });

  test('renders header with title', async function (assert) {
    await render(
      <template>
        <Modal @isOpen={{true}} as |modal|>
          <modal.Header @title="My Modal Title" />
          <modal.Body>Content</modal.Body>
        </Modal>
      </template>
    );

    assert.dom('[data-test-modal-title]').hasText('My Modal Title');
  });

  test('renders footer with actions', async function (assert) {
    await render(
      <template>
        <Modal @isOpen={{true}} as |modal|>
          <modal.Body>Content</modal.Body>
          <modal.Footer>
            <button data-test-cancel type="button">Cancel</button>
            <button data-test-confirm type="button">Confirm</button>
          </modal.Footer>
        </Modal>
      </template>
    );

    assert.dom('[data-test-modal-footer]').exists();
    assert.dom('[data-test-cancel]').exists();
    assert.dom('[data-test-confirm]').exists();
  });

  test('controlled mode with @isOpen and @onClose', async function (assert) {
    let closeCallCount = 0;
    const handleClose = () => closeCallCount++;

    await render(
      <template>
        <Modal @isOpen={{true}} @onClose={{handleClose}} as |modal|>
          <modal.Header @title="Controlled Modal" />
          <modal.Body>Content</modal.Body>
        </Modal>
      </template>
    );

    assert.dom('[data-test-modal]').exists();

    await click('[data-test-modal-close]');

    assert.strictEqual(closeCallCount, 1, 'onClose was called');
    // Modal should still be open because parent controls isOpen
    assert.dom('[data-test-modal]').exists();
  });

  test('exposes close action to children', async function (assert) {
    await render(
      <template>
        <Modal as |modal|>
          <modal.Trigger data-test-trigger>Open</modal.Trigger>
          <modal.Body>
            <button data-test-custom-close type="button" {{on "click" modal.close}}>
              Custom Close
            </button>
          </modal.Body>
        </Modal>
      </template>
    );

    await click('[data-test-trigger]');
    assert.dom('[data-test-modal]').exists();

    await click('[data-test-custom-close]');
    await waitFor('[data-test-modal]', { count: 0 });

    assert.dom('[data-test-modal]').doesNotExist();
  });

  test('applies size class correctly', async function (assert) {
    await render(
      <template>
        <Modal @isOpen={{true}} @size="lg" as |modal|>
          <modal.Body>Large modal content</modal.Body>
        </Modal>
      </template>
    );

    assert.dom('[data-test-modal-content]').hasClass('modal__content--lg');
  });

  test('has correct ARIA attributes', async function (assert) {
    await render(
      <template>
        <Modal @isOpen={{true}} as |modal|>
          <modal.Header @title="Accessible Modal" />
          <modal.Body>Content</modal.Body>
        </Modal>
      </template>
    );

    assert.dom('[data-test-modal]').hasAttribute('role', 'dialog');
    assert.dom('[data-test-modal]').hasAttribute('aria-modal', 'true');
    assert.dom('[data-test-modal]').hasAttribute('aria-labelledby');
  });

  test('traps focus within modal', async function (assert) {
    await render(
      <template>
        <button data-test-outside type="button">Outside</button>
        <Modal @isOpen={{true}} as |modal|>
          <modal.Header @title="Focus Trap Test" />
          <modal.Body>
            <input data-test-input type="text" />
            <button data-test-button type="button">Button</button>
          </modal.Body>
        </Modal>
      </template>
    );

    // Focus should be within the modal
    const modal = document.querySelector('[data-test-modal]');
    const activeElement = document.activeElement;

    assert.true(
      modal?.contains(activeElement),
      'Focus is within modal'
    );
  });

  test('returns focus to trigger when closed', async function (assert) {
    await render(
      <template>
        <Modal as |modal|>
          <modal.Trigger data-test-trigger>Open</modal.Trigger>
          <modal.Header @title="Focus Return Test" />
          <modal.Body>Content</modal.Body>
        </Modal>
      </template>
    );

    await click('[data-test-trigger]');
    await click('[data-test-modal-close]');
    await waitFor('[data-test-modal]', { count: 0 });

    assert.dom('[data-test-trigger]').isFocused();
  });

  test('supports multiple modals stacked', async function (assert) {
    await render(
      <template>
        <Modal as |modal1|>
          <modal1.Trigger data-test-trigger-1>Open First</modal1.Trigger>
          <modal1.Body>
            <p>First modal</p>
            <Modal as |modal2|>
              <modal2.Trigger data-test-trigger-2>Open Second</modal2.Trigger>
              <modal2.Body>
                <p data-test-second-modal>Second modal</p>
              </modal2.Body>
            </Modal>
          </modal1.Body>
        </Modal>
      </template>
    );

    await click('[data-test-trigger-1]');
    await click('[data-test-trigger-2]');

    assert.dom('[data-test-second-modal]').exists();
  });
});
