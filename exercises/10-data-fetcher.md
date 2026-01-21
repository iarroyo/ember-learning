# Exercise 10: Data Fetcher Component

**Difficulty: Difficult**

## Objective

Create a generic data fetcher component that yields loading, error, and success states to its block, enabling flexible async data patterns.

## Requirements

Create a component at `app/components/data-fetcher.gts` that:

1. Accepts a `@fetch` function that returns a Promise
2. Optionally accepts a `@refreshInterval` for periodic refetching
3. Uses `AsyncResource` internally for state management
4. Yields an object with state and data to its block
5. Cleans up interval on destroy

## Component Signature

```typescript
interface DataFetcherSignature<T = unknown> {
  Args: {
    fetch: () => Promise<T>;
    refreshInterval?: number;
  };
  Blocks: {
    default: [
      {
        isLoading: boolean;
        isSuccess: boolean;
        isError: boolean;
        isEmpty: boolean;
        data: T | null;
        error: Error | null;
        retry: () => void;
      },
    ];
  };
  Element: HTMLDivElement;
}
```

## Implementation Details

1. Create AsyncResource with the provided fetch function
2. Call `load()` in constructor
3. If `refreshInterval` is provided, set up a periodic interval
4. Implement `willDestroy` to clean up the interval
5. Yield a hash with all state properties and retry action

## Usage Example

```handlebars
<DataFetcher @fetch={{this.fetchProducts}} as |state|>
  {{#if state.isLoading}}
    <LoadingSpinner />
  {{else if state.isError}}
    <ErrorMessage @error={{state.error}} />
    <button {{on 'click' state.retry}}>Retry</button>
  {{else}}
    {{#each state.data as |product|}}
      <ProductCard @product={{product}} />
    {{/each}}
  {{/if}}
</DataFetcher>
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | data-fetcher` pass.

## Learning Goals

- Generic/reusable component patterns
- Yielding data to blocks
- Component lifecycle (`willDestroy`)
- Interval management and cleanup
