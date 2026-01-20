import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { RenderTrackedItem } from './render-tracked-item';
import type { ListItem } from './render-tracked-item';

/**
 * ItemStore - Encapsulates the tracked array
 *
 * By having `@tracked items` on a separate class, the component
 * holds a STABLE reference to the store instance. Only the `items`
 * property changes, not the store itself.
 */
class ItemStore {
  @tracked items: ListItem[] = [];

  private nextId = 1;

  addItem(): void {
    const newItem: ListItem = {
      id: `optimized-${this.nextId}`,
      label: `Item ${this.nextId}`,
    };
    this.nextId++;

    // Only `items` is tracked and changes
    // The store reference stays stable
    this.items = [...this.items, newItem];
  }
}

interface OptimizedListSignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

/**
 * OPTIMIZED APPROACH - Demonstrates proper reactivity
 *
 * The component holds a stable reference to `store`.
 * When we call `store.addItem()`, only `store.items` changes.
 * Glimmer only re-renders the {{#each}} loop, and with keyed
 * iteration, existing items are preserved in the DOM.
 */
export class OptimizedList extends Component<OptimizedListSignature> {
  // Stable reference - never changes
  store = new ItemStore();

  @action
  addItem(): void {
    this.store.addItem();
  }

  <template>
    <div data-test-optimized-list>
      <h3>Optimized Approach</h3>
      <p>Only new items render when added</p>

      <button
        data-test-optimized-add-button
        type="button"
        {{on "click" this.addItem}}
      >
        Add Item
      </button>

      <div data-test-optimized-items>
        {{#each this.store.items key="id" as |item|}}
          <RenderTrackedItem @item={{item}} data-test-optimized-item>
            <:default as |renderCount|>
              <span data-test-optimized-render-count>{{renderCount}}</span>
            </:default>
          </RenderTrackedItem>
        {{/each}}
      </div>
    </div>
  </template>
}
