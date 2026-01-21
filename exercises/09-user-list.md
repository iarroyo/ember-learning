# Exercise 09: User List Component

**Difficulty: Medium**

## Objective

Create a component that fetches and displays a list of users with loading, error, and retry states using the AsyncResource utility.

## Requirements

Create a component at `app/components/user-list.gts` that:

1. Uses `AsyncResource` to fetch user data
2. Shows a loading skeleton while fetching
3. Displays error state with retry button on failure
4. Renders a `UserCard` for each user when successful
5. Displays user names alongside their cards

## Component Signature

```typescript
interface UserListSignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}
```

## Data Test Attributes

- `[data-test-skeleton]` - Loading indicator
- `[data-test-error]` - Error message
- `[data-test-retry-button]` - Retry button
- `[data-test-user-card]` - Container for each user card
- `[data-test-user-name]` - User name display

## Implementation Details

1. Create an `AsyncResource` with a fetch function in the constructor
2. Call `load()` in the constructor to start fetching
3. Implement a `retry()` action that calls `resource.retry()`
4. Use conditional rendering based on resource state

## Usage Example

```handlebars
<UserList />
```

## Mock Data

```typescript
const mockUsers: User[] = [
  {
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    isOnline: true,
  },
  {
    firstName: 'Jane',
    lastName: 'Smith',
    email: 'jane@example.com',
    isOnline: false,
  },
  {
    firstName: 'Bob',
    lastName: 'Johnson',
    email: 'bob@example.com',
    isOnline: true,
  },
  {
    firstName: 'Alice',
    lastName: 'Williams',
    email: 'alice@example.com',
    isOnline: true,
  },
];
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | user-list` pass.

## Learning Goals

- Composing components with child components
- Using utility classes for async state management
- Handling loading/error/success states
- Iterating with `{{#each}}`
