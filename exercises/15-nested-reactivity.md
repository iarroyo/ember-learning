# Exercise 15: Nested Reactivity and Loop Optimization

**Difficulty: Extreme**

## Objective
Understand how Glimmer's reactivity system handles nested properties and learn to optimize `{{#each}}` loops to prevent unnecessary re-renders when working with lists.

## The Problem

A common pattern that causes performance issues:

```typescript
// Naive approach - items are recreated on each update
class MyComponent extends Component {
  @tracked state = { items: [] };

  addItem(item) {
    // Recreating items (common with API responses or immutable patterns)
    const updatedItems = this.state.items.map(i => ({ ...i }));
    this.state = { ...this.state, items: [...updatedItems, item] };
  }
}
```

This pattern is common when:
- **API responses** return fresh object references each time
- **Immutable data patterns** create new objects on every update
- **Data transformation/mapping** produces new object instances

When item objects are recreated, Glimmer treats them as new items, causing unnecessary re-renders of ALL items in the loop.

## The Solution

Use a dedicated class with `@tracked` on the array property, and maintain stable object references:

```typescript
// Optimized approach - stable object references
class ItemStore {
  @tracked items: Item[] = [];

  addItem(item: Item) {
    // Existing items keep their references
    this.items = [...this.items, item];
  }
}

class MyComponent extends Component {
  store = new ItemStore();

  addItem(item) {
    this.store.addItem(item); // Only new items render
  }
}
```

## Requirements

Create a component group at `app/components/nested-reactivity/` with the following structure:

```
app/components/
├── nested-reactivity.gts          # Main demo component
└── nested-reactivity/
    ├── naive-list.gts             # Demonstrates the problem
    ├── optimized-list.gts         # Demonstrates the solution
    └── render-tracked-item.gts    # Shared item with render counter
```

### 1. Main Component (`app/components/nested-reactivity.gts`)

- Renders both NaiveList and OptimizedList side by side
- Provides a clear visual comparison of the two approaches

### 2. Naive List (`app/components/nested-reactivity/naive-list.gts`)

- Uses `@tracked state = { items: [] }` pattern
- **Recreates ALL item objects** when adding a new item (simulating API/immutable patterns)
- Has an "Add Item" button
- Each item displays a render counter
- Demonstrates that ALL items re-render on each addition

### 3. Optimized List (`app/components/nested-reactivity/optimized-list.gts`)

- Uses a separate `ItemStore` class with `@tracked items`
- **Preserves existing item references** when adding new items
- Has an "Add Item" button
- Each item displays a render counter
- Demonstrates that only NEW items render when added

### 4. Render Tracked Item (`app/components/nested-reactivity/render-tracked-item.gts`)

- Shared component used by both lists
- Displays the item content
- Tracks and displays how many times it has rendered
- Uses a Map to track render counts by item ID

## Component Signatures

```typescript
// nested-reactivity.gts
interface NestedReactivitySignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

// nested-reactivity/naive-list.gts
interface NaiveListSignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

// nested-reactivity/optimized-list.gts
interface OptimizedListSignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

// nested-reactivity/render-tracked-item.gts
interface RenderTrackedItemSignature {
  Args: {
    item: { id: string; label: string };
  };
  Blocks: {
    default: [number]; // yields render count
  };
  Element: HTMLDivElement;
}
```

## Data Test Attributes

### Main Component
- `[data-test-nested-reactivity]` - Main container

### Naive List
- `[data-test-naive-list]` - Container
- `[data-test-naive-add-button]` - Add item button
- `[data-test-naive-item]` - Individual item container
- `[data-test-naive-render-count]` - Render count display for each item

### Optimized List
- `[data-test-optimized-list]` - Container
- `[data-test-optimized-add-button]` - Add item button
- `[data-test-optimized-item]` - Individual item container
- `[data-test-optimized-render-count]` - Render count display for each item

## Expected Behavior

### Naive List (The Problem)
1. Click "Add Item" → Item 1 appears with render count = 1
2. Click "Add Item" → Item 2 appears, **Item 1 now shows render count = 2**
3. Click "Add Item" → Item 3 appears, **Item 1 shows 3, Item 2 shows 2**

### Optimized List (The Solution)
1. Click "Add Item" → Item 1 appears with render count = 1
2. Click "Add Item" → Item 2 appears, **Item 1 still shows render count = 1**
3. Click "Add Item" → Item 3 appears, **All previous items still show count = 1**

## Usage Example

```handlebars
{{! Simply use the main component }}
<NestedReactivity />

{{! Or use individual lists }}
<NestedReactivity::NaiveList />
<NestedReactivity::OptimizedList />
```

## Key Concepts

### Why does the naive approach re-render everything?

When you recreate item objects (common with API responses or immutable patterns), each item gets a new object reference. Even though the data is the same, Glimmer sees new objects and must re-render each component.

```typescript
// This creates NEW objects - triggers re-renders
const updatedItems = items.map(item => ({ ...item }));
```

### Why does the optimized approach work?

By maintaining stable object references, Glimmer can recognize existing items and skip re-rendering them:

```typescript
// Existing items keep their references - no re-render needed
this.items = [...this.items, newItem];
```

### Real-world applications

1. **Memoize API responses**: Use caching or memoization to preserve object references
2. **Entity normalization**: Store entities by ID and reference them
3. **Immutable patterns**: Use libraries that track identity (like Immer)
4. **Class-based stores**: Encapsulate state in classes with tracked properties

## Detecting Re-renders

Track render counts using a Map keyed by item ID:

```typescript
const renderCountsById = new Map<string, number>();

function trackRenderById(id: string): number {
  const count = (renderCountsById.get(id) ?? 0) + 1;
  renderCountsById.set(id, count);
  return count;
}
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | nested-reactivity` pass.

## Learning Goals

- Understanding Glimmer's reactivity and object identity
- Recognizing performance pitfalls with recreated objects
- Optimizing list rendering by preserving references
- Using classes to encapsulate reactive state
- Debugging and visualizing re-render behavior
- Compound component organization patterns
