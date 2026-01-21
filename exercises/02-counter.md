# Exercise 02: Counter Component

**Difficulty: Low**

## Objective

Create an interactive counter component with increment, decrement, and reset functionality.

## Requirements

Create a component at `app/components/counter.gts` that:

1. Displays a count value (starting at 0 by default)
2. Accepts an optional `@initialValue` argument
3. Has an increment button that increases the count by 1
4. Has a decrement button that decreases the count by 1
5. Has a reset button that returns to the initial value
6. The count can go negative

## Component Signature

```typescript
interface CounterSignature {
  Args: {
    initialValue?: number;
  };
  Element: HTMLDivElement;
}
```

## Data Test Attributes

- `[data-test-count]` - Element displaying the current count
- `[data-test-increment]` - Increment button
- `[data-test-decrement]` - Decrement button
- `[data-test-reset]` - Reset button

## Usage Example

```handlebars
<Counter />
{{! Starts at 0 }}

<Counter @initialValue={{10}} />
{{! Starts at 10 }}
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | counter` pass.

## Learning Goals

- Using `@tracked` for reactive state
- Handling user interactions with `{{on "click"}}`
- Using `@action` decorator for event handlers
- Working with optional arguments and default values
