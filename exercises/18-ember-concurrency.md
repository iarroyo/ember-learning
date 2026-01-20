# Exercise 18: Ember Concurrency

**Difficulty: Difficult**

**Prerequisites:** Exercise 11 (Async Resource)

## Objective
Learn how to use `ember-concurrency` for managing async operations with automatic cancellation, loading states, and the `lastSuccessful` pattern for showing stale data while revalidating.

## Why Ember Concurrency?

While `AsyncResource` (Exercise 11) works well, `ember-concurrency` provides:
- Automatic cancellation when component is destroyed
- Built-in `isRunning`, `lastSuccessful`, `lastComplete` states
- Task modifiers like `drop`, `restartable`, `enqueue`
- No need for `isDestroying` checks or manual cleanup

## Key Concepts

### 1. Basic Task Definition

```typescript
import { task, timeout } from 'ember-concurrency';

class MyComponent extends Component {
  searchTask = task(async (query: string) => {
    await timeout(300); // debounce
    const response = await fetch(`/api/search?q=${query}`);
    return response.json();
  });

  @action
  search(query: string) {
    this.searchTask.perform(query);
  }
}
```

### 2. `lastSuccessful` Pattern

Show stale data while loading new data:

```handlebars
{{#if this.searchTask.isRunning}}
  <LoadingSpinner />
{{/if}}

{{!-- lastSuccessful keeps showing old results while new search runs --}}
{{#each this.searchTask.lastSuccessful.value as |result|}}
  <ResultItem @result={{result}} />
{{/each}}
```

### 3. Task Instance Independence

**Important:** Each component instance has its OWN task instance. Calling `cancelAll()` on one component does NOT affect tasks in other components:

```typescript
// Component A
class SearchBoxA extends Component {
  searchTask = task(async (q) => { /* ... */ });

  @action cancel() {
    this.searchTask.cancelAll(); // Only cancels THIS component's task
  }
}

// Component B - has its own independent searchTask
class SearchBoxB extends Component {
  searchTask = task(async (q) => { /* ... */ });
  // Cancelling in A does NOT affect B's task!
}
```

### 4. Sharing Tasks via Service

To share a task across components (so `cancelAll()` affects all), define it in a service:

```typescript
// app/services/search.ts
export default class SearchService extends Service {
  searchTask = task(async (query: string) => {
    const response = await fetch(`/api/search?q=${query}`);
    return response.json();
  });
}

// Any component
class MyComponent extends Component {
  @service declare search: SearchService;

  @action
  doSearch(query: string) {
    this.search.searchTask.perform(query);
  }

  @action
  cancelAll() {
    // This cancels the task for ALL components using this service
    this.search.searchTask.cancelAll();
  }
}
```

## Requirements

### Part 1: Component with Independent Task

Create `app/components/search-box.gts` that:

1. Has a `searchTask` using `restartable` modifier (cancels previous on new search)
2. Accepts `@onResults` callback
3. Shows loading indicator while searching
4. Uses `lastSuccessful` to keep showing previous results during search
5. Has a cancel button that only cancels THIS component's task

### Part 2: Service with Shared Task

Create `app/services/global-search.ts` that:

1. Defines a shared `searchTask`
2. Tracks search history
3. Provides `cancelAll()` that affects all consumers

Create `app/components/global-search-box.gts` that uses the service.

## Component Signatures

```typescript
// SearchBox - independent task
interface SearchBoxSignature {
  Args: {
    onResults?: (results: SearchResult[]) => void;
    placeholder?: string;
  };
  Element: HTMLDivElement;
}

// GlobalSearchBox - uses shared service task
interface GlobalSearchBoxSignature {
  Args: {
    placeholder?: string;
  };
  Element: HTMLDivElement;
}
```

## Data Test Attributes

- `[data-test-search-input]` - Search input field
- `[data-test-search-loading]` - Loading indicator
- `[data-test-search-cancel]` - Cancel button
- `[data-test-search-result]` - Individual result item
- `[data-test-search-results-count]` - Results count display

## Task Modifiers

| Modifier | Behavior |
|----------|----------|
| `restartable` | Cancels previous task when new one starts |
| `drop` | Ignores new performs while running |
| `enqueue` | Queues new performs to run after current |
| `keepLatest` | Like drop, but keeps the last dropped to run after |

## Usage Example

```handlebars
{{!-- Two independent search boxes --}}
<SearchBox @placeholder="Search products..." />
<SearchBox @placeholder="Search users..." />
{{!-- Cancelling one doesn't affect the other --}}

{{!-- Two boxes sharing the same task via service --}}
<GlobalSearchBox @placeholder="Global search 1" />
<GlobalSearchBox @placeholder="Global search 2" />
{{!-- Cancelling one cancels both! --}}
```

## Tests to Pass

Run `npm test` and ensure all tests in:
- `Integration | Component | search-box`
- `Integration | Component | global-search-box`
- `Unit | Service | global-search`

## Learning Goals

- Defining tasks with `task()` from ember-concurrency
- Using task modifiers (`restartable`, `drop`, etc.)
- Understanding `lastSuccessful` for stale-while-revalidate pattern
- Recognizing that task instances are independent per component
- Sharing tasks across components via services
- Automatic cleanup without `isDestroying` checks
