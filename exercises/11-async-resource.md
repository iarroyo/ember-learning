# Exercise 11: Async Resource Utility

**Difficulty: Difficult**

## Objective
Create a reusable utility class for managing async data fetching with loading, error, and success states.

## Requirements

Create a utility at `app/utils/async-resource.ts` that:

1. Manages loading, error, and success states with `@tracked`
2. Stores fetched data and any errors
3. Supports cancellation via AbortController
4. Provides retry, cancel, and reset methods
5. Has an `isEmpty` getter for array data

## Class Interface

```typescript
export class AsyncResource<T = unknown> {
  @tracked isLoading: boolean;
  @tracked isError: boolean;
  @tracked isSuccess: boolean;
  @tracked data: T | null;
  @tracked error: Error | null;

  constructor(fetchFn: (signal?: AbortSignal) => Promise<T>);

  async load(): Promise<void>;
  retry(): Promise<void>;
  cancel(): void;
  reset(): void;

  get isEmpty(): boolean;
}
```

## Behavior Details

### load()
1. Set loading state, clear errors
2. Create new AbortController
3. Execute fetch function with signal
4. On success: store data, set success state
5. On error: store error, set error state (unless AbortError)
6. Always clear loading state in finally

### retry()
- Simply calls `load()` again

### cancel()
- Aborts the current request via AbortController

### reset()
- Clears all state to initial values
- Cancels any pending request

### isEmpty
- Returns true if data is an array with length 0

## Usage Example

```typescript
const resource = new AsyncResource(async (signal) => {
  const response = await fetch('/api/users', { signal });
  return response.json();
});

await resource.load();

if (resource.isSuccess) {
  console.log(resource.data);
}
```

## Tests to Pass

Run `npm test` and ensure all tests in `Unit | Utility | async-resource` pass.

## Learning Goals

- Creating utility classes in Ember
- Using `@tracked` outside components
- AbortController for request cancellation
- Generic TypeScript patterns
