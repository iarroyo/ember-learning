# Exercise 17: Test Waiters for Async Operations

**Difficulty: Medium**

## Objective
Learn how to use `@ember/test-waiters` to ensure tests properly wait for async operations to complete, preventing flaky tests and race conditions.

## The Problem

When components perform async operations, tests may assert before the operation completes:

```typescript
// Component with async operation
class MyComponent extends Component {
  @tracked isLoading = false;
  @tracked result = null;

  @action
  async fetchData() {
    this.isLoading = true;
    this.result = await fetch('/api/data'); // Tests don't wait for this!
    this.isLoading = false;
  }
}

// Test - MAY FAIL due to race condition
test('it shows result after fetch', async function(assert) {
  await render(<template><MyComponent /></template>);
  await click('[data-test-fetch]');
  // This might assert before fetchData completes!
  assert.dom('[data-test-result]').exists();
});
```

## The Solution: Test Waiters

### 1. `waitForPromise` - Simple Wrapper

Wrap any promise to make tests wait for it:

```typescript
import { waitForPromise } from '@ember/test-waiters';

class MyComponent extends Component {
  @action
  async fetchData() {
    this.isLoading = true;
    // Tests will wait for this promise to resolve
    this.result = await waitForPromise(fetch('/api/data'));
    this.isLoading = false;
  }
}
```

### 2. `buildWaiter` - Fine-Grained Control

For complex scenarios where you need explicit begin/end control:

```typescript
import { buildWaiter } from '@ember/test-waiters';

const waiter = buildWaiter('my-component:async-operation');

class MyComponent extends Component {
  @action
  async complexOperation() {
    const token = waiter.beginAsync();
    try {
      // Multiple async steps...
      await step1();
      await step2();
      await step3();
    } finally {
      waiter.endAsync(token);
    }
  }
}
```

## Requirements

Create a component at `app/components/async-button.gts` that:

1. Accepts an `@onClick` async callback
2. Shows loading state while the callback executes
3. Shows success state briefly after completion
4. Shows error state if the callback throws
5. Uses `waitForPromise` to ensure tests wait for the operation
6. Disables the button during loading

Also create a utility at `app/utils/debounced-search.ts` that:

1. Performs debounced search with `buildWaiter`
2. Demonstrates explicit begin/end async control

## Component Signature

```typescript
interface AsyncButtonSignature {
  Args: {
    onClick: () => Promise<void>;
    label?: string;
    loadingLabel?: string;
    successLabel?: string;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLButtonElement;
}
```

## Data Test Attributes

- `[data-test-async-button]` - The button element
- `[data-test-async-button-loading]` - Present when loading
- `[data-test-async-button-success]` - Present when showing success
- `[data-test-async-button-error]` - Present when showing error

## Implementation Details

### AsyncButton Component

```typescript
import { waitForPromise } from '@ember/test-waiters';

export class AsyncButton extends Component {
  @tracked state: 'idle' | 'loading' | 'success' | 'error' = 'idle';

  @action
  async handleClick() {
    this.state = 'loading';
    try {
      // waitForPromise ensures tests wait for this
      await waitForPromise(this.args.onClick());
      this.state = 'success';
      // Reset to idle after showing success
      await waitForPromise(new Promise(r => setTimeout(r, 1500)));
      this.state = 'idle';
    } catch {
      this.state = 'error';
    }
  }
}
```

### DebouncedSearch Utility

```typescript
import { buildWaiter } from '@ember/test-waiters';

const waiter = buildWaiter('debounced-search:search');

export class DebouncedSearch {
  private timeoutId: number | null = null;
  private currentToken: unknown = null;

  search(query: string, callback: (q: string) => Promise<void>, delay = 300) {
    // Cancel previous
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
      if (this.currentToken) {
        waiter.endAsync(this.currentToken);
      }
    }

    // Begin new async operation
    this.currentToken = waiter.beginAsync();

    this.timeoutId = window.setTimeout(async () => {
      try {
        await callback(query);
      } finally {
        waiter.endAsync(this.currentToken);
        this.currentToken = null;
      }
    }, delay);
  }
}
```

## Usage Example

```handlebars
<AsyncButton
  @onClick={{this.saveData}}
  @label="Save"
  @loadingLabel="Saving..."
  @successLabel="Saved!"
/>
```

```typescript
// In test - no special handling needed!
test('button shows loading then success', async function(assert) {
  await render(<template>
    <AsyncButton @onClick={{this.slowOperation}} @label="Save" />
  </template>);

  await click('[data-test-async-button]');

  // Test automatically waits for waitForPromise to resolve
  assert.dom('[data-test-async-button-success]').exists();
});
```

## Tests to Pass

Run `npm test` and ensure all tests in:
- `Integration | Component | async-button`
- `Unit | Utility | debounced-search`

## Learning Goals

- Understanding why tests need to wait for async operations
- Using `waitForPromise` for simple async wrapping
- Using `buildWaiter` with `beginAsync`/`endAsync` for complex scenarios
- Preventing flaky tests caused by race conditions
- Testing loading/success/error states
