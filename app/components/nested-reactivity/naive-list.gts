import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { RenderTrackedItem } from './render-tracked-item';
import type { ListItem } from './render-tracked-item';

interface NaiveListState {
  items: ListItem[];
  lastUpdated: number;
}

interface NaiveListSignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

/**
 * NAIVE APPROACH - Demonstrates the re-render problem
 *
 * This component stores items inside a tracked object. When we update
 * the state, we recreate all item objects to demonstrate what happens
 * when item identity is lost.
 *
 * This pattern commonly occurs when:
 * - Fetching data from an API returns new object references each time
 * - Using immutable data patterns that create new objects on every update
 * - Transforming/mapping data in a way that creates new objects
 */
export class NaiveList extends Component<NaiveListSignature> {
  @tracked state: NaiveListState = { items: [], lastUpdated: 0 };

  private nextId = 1;

  @action
  addItem(): void {
    const newItem: ListItem = {
      id: `naive-${this.nextId}`,
      label: `Item ${this.nextId}`,
    };
    this.nextId++;

    // Recreate ALL items with new object references
    // This simulates what happens when you fetch fresh data from an API
    // or use immutable data patterns without memoization
    const recreatedItems = this.state.items.map((item) => ({
      ...item, // Creates a NEW object reference
    }));

    this.state = {
      items: [...recreatedItems, newItem],
      lastUpdated: Date.now(),
    };
  }

  <template>
    <div data-test-naive-list>
      <h3>Naive Approach</h3>
      <p>All items re-render when a new item is added (items are recreated)</p>

      <button
        data-test-naive-add-button
        type="button"
        {{on "click" this.addItem}}
      >
        Add Item
      </button>

      <div data-test-naive-items>
        {{#each this.state.items key="id" as |item|}}
          <RenderTrackedItem @item={{item}} data-test-naive-item>
            <:default as |renderCount|>
              <span data-test-naive-render-count>{{renderCount}}</span>
            </:default>
          </RenderTrackedItem>
        {{/each}}
      </div>
    </div>
  </template>
}
