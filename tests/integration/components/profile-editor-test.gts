import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, fillIn, click } from '@ember/test-helpers';
import { ProfileEditor } from 'ember-learning/components/profile-editor';
import type { ProfileData } from 'ember-learning/components/profile-editor';

module('Integration | Component | profile-editor', function (hooks) {
  setupRenderingTest(hooks);

  module('object mode (anti-pattern)', function () {
    test('it renders in object mode', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="object" />
        </template>
      );

      assert.dom('[data-test-profile-editor]').exists();
      assert.dom('[data-test-mode="object"]').exists();
      assert.dom('[data-test-first-name]').exists();
      assert.dom('[data-test-last-name]').exists();
      assert.dom('[data-test-email]').exists();
      assert.dom('[data-test-bio]').exists();
    });

    test('it updates firstName correctly', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="object" />
        </template>
      );

      await fillIn('[data-test-first-name]', 'John');
      assert.dom('[data-test-first-name]').hasValue('John');
      assert.dom('[data-test-full-name]').hasText('John');
    });

    test('it updates lastName correctly', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="object" />
        </template>
      );

      await fillIn('[data-test-last-name]', 'Doe');
      assert.dom('[data-test-last-name]').hasValue('Doe');
      assert.dom('[data-test-full-name]').hasText('Doe');
    });

    test('fullName combines firstName and lastName', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="object" />
        </template>
      );

      await fillIn('[data-test-first-name]', 'John');
      await fillIn('[data-test-last-name]', 'Doe');
      assert.dom('[data-test-full-name]').hasText('John Doe');
    });

    test('save button is disabled when invalid', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="object" />
        </template>
      );

      assert.dom('[data-test-save-button]').isDisabled();

      await fillIn('[data-test-first-name]', 'John');
      assert.dom('[data-test-save-button]').isDisabled();

      await fillIn('[data-test-email]', 'john@example.com');
      assert.dom('[data-test-save-button]').isNotDisabled();
    });

    test('onSave is called with profile data', async function (assert) {
      let savedData: ProfileData | null = null;
      const handleSave = (data: ProfileData) => {
        savedData = data;
      };

      await render(
        <template>
          <ProfileEditor @mode="object" @onSave={{handleSave}} />
        </template>
      );

      await fillIn('[data-test-first-name]', 'John');
      await fillIn('[data-test-last-name]', 'Doe');
      await fillIn('[data-test-email]', 'john@example.com');
      await fillIn('[data-test-bio]', 'Hello world');

      await click('[data-test-save-button]');

      assert.deepEqual(savedData, {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        bio: 'Hello world',
      });
    });

    test('reset clears all fields', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="object" />
        </template>
      );

      await fillIn('[data-test-first-name]', 'John');
      await fillIn('[data-test-last-name]', 'Doe');
      await fillIn('[data-test-email]', 'john@example.com');

      await click('[data-test-reset-button]');

      assert.dom('[data-test-first-name]').hasValue('');
      assert.dom('[data-test-last-name]').hasValue('');
      assert.dom('[data-test-email]').hasValue('');
      assert.dom('[data-test-full-name]').hasText('(empty)');
    });

    test('render count increments on each field change', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="object" />
        </template>
      );

      const initialCount = parseInt(
        document.querySelector('[data-test-render-count]')?.textContent ?? '0'
      );

      await fillIn('[data-test-first-name]', 'J');

      const afterFirstName = parseInt(
        document.querySelector('[data-test-render-count]')?.textContent ?? '0'
      );

      assert.true(
        afterFirstName > initialCount,
        'render count increased after firstName change'
      );

      await fillIn('[data-test-email]', 'j');

      const afterEmail = parseInt(
        document.querySelector('[data-test-render-count]')?.textContent ?? '0'
      );

      assert.true(
        afterEmail > afterFirstName,
        'render count increased after email change'
      );
    });
  });

  module('granular mode (recommended)', function () {
    test('it renders in granular mode', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="granular" />
        </template>
      );

      assert.dom('[data-test-profile-editor]').exists();
      assert.dom('[data-test-mode="granular"]').exists();
      assert.dom('[data-test-first-name]').exists();
      assert.dom('[data-test-last-name]').exists();
      assert.dom('[data-test-email]').exists();
      assert.dom('[data-test-bio]').exists();
    });

    test('it updates firstName correctly', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="granular" />
        </template>
      );

      await fillIn('[data-test-first-name]', 'Jane');
      assert.dom('[data-test-first-name]').hasValue('Jane');
      assert.dom('[data-test-full-name]').hasText('Jane');
    });

    test('it updates lastName correctly', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="granular" />
        </template>
      );

      await fillIn('[data-test-last-name]', 'Smith');
      assert.dom('[data-test-last-name]').hasValue('Smith');
      assert.dom('[data-test-full-name]').hasText('Smith');
    });

    test('fullName combines firstName and lastName', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="granular" />
        </template>
      );

      await fillIn('[data-test-first-name]', 'Jane');
      await fillIn('[data-test-last-name]', 'Smith');
      assert.dom('[data-test-full-name]').hasText('Jane Smith');
    });

    test('save button is disabled when invalid', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="granular" />
        </template>
      );

      assert.dom('[data-test-save-button]').isDisabled();

      await fillIn('[data-test-first-name]', 'Jane');
      assert.dom('[data-test-save-button]').isDisabled();

      await fillIn('[data-test-email]', 'jane@example.com');
      assert.dom('[data-test-save-button]').isNotDisabled();
    });

    test('onSave is called with profile data', async function (assert) {
      let savedData: ProfileData | null = null;
      const handleSave = (data: ProfileData) => {
        savedData = data;
      };

      await render(
        <template>
          <ProfileEditor @mode="granular" @onSave={{handleSave}} />
        </template>
      );

      await fillIn('[data-test-first-name]', 'Jane');
      await fillIn('[data-test-last-name]', 'Smith');
      await fillIn('[data-test-email]', 'jane@example.com');
      await fillIn('[data-test-bio]', 'Goodbye world');

      await click('[data-test-save-button]');

      assert.deepEqual(savedData, {
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
        bio: 'Goodbye world',
      });
    });

    test('reset clears all fields', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="granular" />
        </template>
      );

      await fillIn('[data-test-first-name]', 'Jane');
      await fillIn('[data-test-last-name]', 'Smith');
      await fillIn('[data-test-email]', 'jane@example.com');

      await click('[data-test-reset-button]');

      assert.dom('[data-test-first-name]').hasValue('');
      assert.dom('[data-test-last-name]').hasValue('');
      assert.dom('[data-test-email]').hasValue('');
      assert.dom('[data-test-full-name]').hasText('(empty)');
    });

    test('render count increments on field changes', async function (assert) {
      await render(
        <template>
          <ProfileEditor @mode="granular" />
        </template>
      );

      const initialCount = parseInt(
        document.querySelector('[data-test-render-count]')?.textContent ?? '0'
      );

      await fillIn('[data-test-first-name]', 'J');

      const afterFirstName = parseInt(
        document.querySelector('[data-test-render-count]')?.textContent ?? '0'
      );

      assert.true(
        afterFirstName > initialCount,
        'render count increased after firstName change'
      );
    });
  });

  module('both modes comparison', function () {
    test('both modes produce the same output', async function (assert) {
      let objectData: ProfileData | null = null;
      let granularData: ProfileData | null = null;

      const handleObjectSave = (data: ProfileData) => {
        objectData = data;
      };
      const handleGranularSave = (data: ProfileData) => {
        granularData = data;
      };

      await render(
        <template>
          <div data-test-object>
            <ProfileEditor @mode="object" @onSave={{handleObjectSave}} />
          </div>
          <div data-test-granular>
            <ProfileEditor @mode="granular" @onSave={{handleGranularSave}} />
          </div>
        </template>
      );

      // Fill both forms with same data
      await fillIn('[data-test-object] [data-test-first-name]', 'Test');
      await fillIn('[data-test-object] [data-test-last-name]', 'User');
      await fillIn('[data-test-object] [data-test-email]', 'test@example.com');
      await fillIn('[data-test-object] [data-test-bio]', 'Bio text');

      await fillIn('[data-test-granular] [data-test-first-name]', 'Test');
      await fillIn('[data-test-granular] [data-test-last-name]', 'User');
      await fillIn('[data-test-granular] [data-test-email]', 'test@example.com');
      await fillIn('[data-test-granular] [data-test-bio]', 'Bio text');

      // Save both
      await click('[data-test-object] [data-test-save-button]');
      await click('[data-test-granular] [data-test-save-button]');

      // Both should produce identical data
      assert.deepEqual(objectData, granularData);
    });

    test('fullName derived state works in both modes', async function (assert) {
      await render(
        <template>
          <div data-test-object>
            <ProfileEditor @mode="object" />
          </div>
          <div data-test-granular>
            <ProfileEditor @mode="granular" />
          </div>
        </template>
      );

      await fillIn('[data-test-object] [data-test-first-name]', 'Alice');
      await fillIn('[data-test-object] [data-test-last-name]', 'Wonder');

      await fillIn('[data-test-granular] [data-test-first-name]', 'Alice');
      await fillIn('[data-test-granular] [data-test-last-name]', 'Wonder');

      assert.dom('[data-test-object] [data-test-full-name]').hasText('Alice Wonder');
      assert.dom('[data-test-granular] [data-test-full-name]').hasText('Alice Wonder');
    });
  });
});
