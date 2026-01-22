import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render } from '@ember/test-helpers';
import { tracked } from '@glimmer/tracking';

class RenderResolver {
  declare promise: Promise<unknown>;
  declare resolver: (value: unknown) => void;
  renderIntention() {
    this.promise = new Promise((r) => (this.resolver = r));
  }
}

module('Integration | Component | profile-editor', function (hooks) {
  setupRenderingTest(hooks);

  /**
   * These tests demonstrate WHY using a single @tracked object is an anti-pattern
   * compared to using individual @tracked properties.
   */
  module('anti-pattern demonstrations', function () {
    /**
     * ASPECT 1: Verbose updates
     * Every change requires spreading the entire object: { ...this.state, field: value }
     */
    test('object mode requires verbose spread pattern for each update', function (assert) {
      // Object mode: must spread entire object to trigger reactivity
      class ObjectMode {
        @tracked state = { firstName: '', lastName: '', email: '', bio: '' };

        updateFirstName(v: string) {
          this.state = { ...this.state, firstName: v };
        }
        updateLastName(v: string) {
          this.state = { ...this.state, lastName: v };
        }
        updateEmail(v: string) {
          this.state = { ...this.state, email: v };
        }
        updateBio(v: string) {
          this.state = { ...this.state, bio: v };
        }
      }

      // Granular mode: simple direct assignment
      class GranularMode {
        @tracked firstName = '';
        @tracked lastName = '';
        @tracked email = '';
        @tracked bio = '';

        updateFirstName(v: string) {
          this.firstName = v;
        }
        updateLastName(v: string) {
          this.lastName = v;
        }
        updateEmail(v: string) {
          this.email = v;
        }
        updateBio(v: string) {
          this.bio = v;
        }
      }

      const objMode = new ObjectMode();
      const granMode = new GranularMode();

      objMode.updateFirstName('John');
      granMode.updateFirstName('John');

      assert.strictEqual(
        objMode.state.firstName,
        'John',
        'Object mode updated'
      );
      assert.strictEqual(granMode.firstName, 'John', 'Granular mode updated');

      // The verbosity difference is visible in the code above:
      // Object:   this.state = { ...this.state, firstName: v }  (spread 4 fields)
      // Granular: this.firstName = v                            (direct assignment)
    });

    /**
     * ASPECT 2: All consumers re-render
     * Any component using this.state re-renders on ANY field change
     */
    test('object mode: changing one field invalidates entire state object', async function (assert) {
      let gettersRenderCounter = 0;
      const renderResolver = new RenderResolver();
      class StateConsumer {
        @tracked state = { firstName: 'A', lastName: 'B', email: 'C' };

        // These getters simulate different UI sections consuming specific fields
        get firstNameDisplay() {
          gettersRenderCounter++;
          return this.state.firstName;
        }
        get lastNameDisplay() {
          gettersRenderCounter++;
          renderResolver.resolver?.(null);
          return this.state.lastName;
        }
        get emailDisplay() {
          gettersRenderCounter++;
          return this.state.email;
        }

        updateFirstName(v: string) {
          this.state = { ...this.state, firstName: v };
          renderResolver.renderIntention();
        }
      }

      const consumer = new StateConsumer();
      const originalRef = consumer.state;

      await render(
        <template>
          <div>{{consumer.lastNameDisplay}}</div>
        </template>
      );

      assert.strictEqual(
        gettersRenderCounter,
        1,
        'lastNameDisplay getter is rendered in the template'
      );

      // Update only firstName
      consumer.updateFirstName('X');

      // This renderResolver ensures thw getter is consumed prior the assertion
      await renderResolver.promise;
      assert.strictEqual(
        gettersRenderCounter,
        2,
        'lastNameDisplay getter is re-rendered despite only firstName was updated'
      );

      // The ENTIRE state object is now a new reference
      assert.notStrictEqual(
        consumer.state,
        originalRef,
        'State object reference changed even though only firstName was updated'
      );

      // Other fields are unchanged in value, but would still cause re-renders
      // because any getter accessing this.state is invalidated
      assert.strictEqual(
        consumer.state.lastName,
        'B',
        'lastName value unchanged but its consumers would re-render'
      );
      assert.strictEqual(
        consumer.state.email,
        'C',
        'email value unchanged but its consumers would re-render'
      );
    });

    /**
     * ASPECT 3: Performance overhead
     * Creates a new object on every keystroke
     */
    test('object mode creates new object on every keystroke', function (assert) {
      const objectReferences: object[] = [];

      class ObjectTracker {
        @tracked state = { firstName: '', lastName: '' };

        updateFirstName(v: string) {
          this.state = { ...this.state, firstName: v };
          objectReferences.push(this.state);
        }
      }

      const tracker = new ObjectTracker();

      // Simulate typing "hello" - 5 keystrokes
      tracker.updateFirstName('h');
      tracker.updateFirstName('he');
      tracker.updateFirstName('hel');
      tracker.updateFirstName('hell');
      tracker.updateFirstName('hello');

      assert.strictEqual(
        objectReferences.length,
        5,
        'Created 5 new objects for 5 keystrokes'
      );

      // Each reference is a different object
      const uniqueRefs = new Set(objectReferences);
      assert.strictEqual(
        uniqueRefs.size,
        5,
        'All 5 objects are unique references (memory allocation on each keystroke)'
      );
    });

    /**
     * ASPECT 4: Easy to forget
     * Mutating this.state.firstName = value silently fails to trigger updates
     */
    test('object mode: direct mutation silently fails to trigger reactivity', function (assert) {
      class BrokenObjectMode {
        @tracked state = { firstName: '', lastName: '' };

        // WRONG: Direct mutation - Ember won't detect this!
        updateWrong(value: string) {
          this.state.firstName = value;
        }

        // CORRECT: Must create new object reference
        updateCorrect(value: string) {
          this.state = { ...this.state, firstName: value };
        }
      }

      const demo = new BrokenObjectMode();
      const initialRef = demo.state;

      // Direct mutation - changes the value but doesn't trigger tracking
      demo.updateWrong('John');

      assert.strictEqual(
        demo.state,
        initialRef,
        'Object reference UNCHANGED after direct mutation - tracking not triggered'
      );
      assert.strictEqual(
        demo.state.firstName,
        'John',
        'Value was mutated internally but UI would not update'
      );

      // Now use the correct pattern
      demo.updateCorrect('Jane');

      assert.notStrictEqual(
        demo.state,
        initialRef,
        'Object reference CHANGED after spread update - tracking triggered'
      );
      assert.strictEqual(
        demo.state.firstName,
        'Jane',
        'Value updated and properly tracked'
      );
    });
  });
});
