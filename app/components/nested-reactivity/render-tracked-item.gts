import Component from '@glimmer/component';

export interface ListItem {
  id: string;
  label: string;
}

interface RenderTrackedItemSignature {
  Args: {
    item: ListItem;
  };
  Blocks: {
    default: [number]; // yields render count
  };
  Element: HTMLDivElement;
}

// Track render counts by item ID (persists across object recreations)
const renderCountsById = new Map<string, number>();

function trackRenderById(id: string): number {
  const count = (renderCountsById.get(id) ?? 0) + 1;
  renderCountsById.set(id, count);
  return count;
}

// Export for tests to reset state between tests
export function resetRenderCounts(): void {
  renderCountsById.clear();
}

export class RenderTrackedItem extends Component<RenderTrackedItemSignature> {
  // This getter runs on every render, incrementing the count for this item's ID
  get renderCount(): number {
    return trackRenderById(this.args.item.id);
  }

  <template>
    <div ...attributes>
      <span data-test-label>{{@item.label}}</span>
      <span data-test-render-count>{{this.renderCount}}</span>
      {{yield this.renderCount}}
    </div>
  </template>
}
