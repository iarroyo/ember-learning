import Component from '@glimmer/component';
import { NaiveList } from './nested-reactivity/naive-list';
import { OptimizedList } from './nested-reactivity/optimized-list';

interface NestedReactivitySignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

/**
 * NestedReactivity - Demonstrates Glimmer reactivity with nested objects
 *
 * This component shows two approaches side by side:
 *
 * 1. NAIVE: Using @tracked on an object with nested arrays
 *    - When the object reference changes, ALL items re-render
 *    - Each item's render count increases with every addition
 *
 * 2. OPTIMIZED: Using a class with @tracked on the array itself
 *    - Only the array property is tracked, not the container
 *    - Only NEW items render, existing items are preserved
 *    - Each item's render count stays at 1
 *
 * Watch the render counts to see the difference in behavior!
 */
export class NestedReactivity extends Component<NestedReactivitySignature> {
  <template>
    <div data-test-nested-reactivity>
      <h2>Nested Reactivity Demo</h2>
      <p>
        Compare the render counts between the two approaches.
        In the naive approach, all items re-render when a new item is added.
        In the optimized approach, only the new item renders.
      </p>

      <div style="display: flex; gap: 2rem; margin-top: 1rem;">
        <div style="flex: 1; padding: 1rem; border: 1px solid #ccc;">
          <NaiveList />
        </div>

        <div style="flex: 1; padding: 1rem; border: 1px solid #ccc;">
          <OptimizedList />
        </div>
      </div>
    </div>
  </template>
}
