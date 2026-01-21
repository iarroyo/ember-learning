# Exercise 15: Alert Component

**Difficulty: Medium**

## Objective

Create an alert component that demonstrates using `@tracked` properties and computed getters for dynamic classes, instead of imperative DOM manipulation with `{{did-insert}}` or `{{did-update}}` modifiers.

## Why @tracked Over Lifecycle Modifiers?

### Anti-pattern (Imperative)

```typescript
// DON'T do this - imperative class manipulation
export class Alert extends Component {
  @action
  updateVariant(element: HTMLElement, [variant]: [string]) {
    // Manually remove old classes and add new ones
    element.classList.remove('bg-blue-100', 'bg-green-100', 'bg-yellow-100', 'bg-red-100');
    element.classList.remove('text-blue-800', 'text-green-800', 'text-yellow-800', 'text-red-800');

    const colors = {
      info: ['bg-blue-100', 'text-blue-800'],
      success: ['bg-green-100', 'text-green-800'],
      warning: ['bg-yellow-100', 'text-yellow-800'],
      error: ['bg-red-100', 'text-red-800'],
    };
    element.classList.add(...colors[variant]);
  }

  <template>
    <div
      class="p-4 rounded-lg"
      {{did-insert this.updateVariant @variant}}
      {{did-update this.updateVariant @variant}}
    >
      {{yield}}
    </div>
  </template>
}
```

### Correct Pattern (Declarative)

```typescript
// DO this - declarative with computed getter
export class Alert extends Component {
  get variantClasses() {
    const variants = {
      info: 'bg-blue-100 text-blue-800',
      success: 'bg-green-100 text-green-800',
      warning: 'bg-yellow-100 text-yellow-800',
      error: 'bg-red-100 text-red-800',
    };
    return variants[this.args.variant ?? 'info'];
  }

  <template>
    <div class="p-4 rounded-lg {{this.variantClasses}}">
      {{yield}}
    </div>
  </template>
}
```

The declarative approach is:

- Easier to test (check classes directly, no DOM state)
- Easier to reason about (data flows one direction)
- More performant (Glimmer optimizes reactive updates)
- SSR-compatible (no reliance on DOM APIs)

## Requirements

Create a component at `app/components/alert.gts` that:

1. Accepts a `@variant` argument: `'info'` | `'success'` | `'warning'` | `'error'` (default: `'info'`)
2. Accepts an optional `@dismissible` argument (default: false)
3. When dismissible, shows a close button that hides the alert
4. Uses computed getters for variant-specific Tailwind classes
5. Yields content for the alert message

## Component Signature

```typescript
interface AlertSignature {
  Args: {
    variant?: 'info' | 'success' | 'warning' | 'error';
    dismissible?: boolean;
    onDismiss?: () => void;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}
```

## Tailwind Classes by Variant

| Variant | Background      | Text              | Border (optional)   |
| ------- | --------------- | ----------------- | ------------------- |
| info    | `bg-blue-100`   | `text-blue-800`   | `border-blue-300`   |
| success | `bg-green-100`  | `text-green-800`  | `border-green-300`  |
| warning | `bg-yellow-100` | `text-yellow-800` | `border-yellow-300` |
| error   | `bg-red-100`    | `text-red-800`    | `border-red-300`    |

## Data Test Attributes

- `[data-test-alert]` - The alert container
- `[data-test-alert-dismiss]` - The dismiss/close button

## Usage Example

```handlebars
{{! Basic info alert }}
<Alert>This is an informational message.</Alert>

{{! Success alert }}
<Alert @variant='success'>Operation completed successfully!</Alert>

{{! Dismissible error alert }}
<Alert @variant='error' @dismissible={{true}}>
  Something went wrong. Please try again.
</Alert>

{{! With callback }}
<Alert
  @variant='warning'
  @dismissible={{true}}
  @onDismiss={{this.handleDismiss}}
>
  Your session will expire soon.
</Alert>
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | alert` pass.

## Learning Goals

- Using computed getters for reactive class names instead of lifecycle modifiers
- Understanding declarative vs imperative patterns in Ember
- Mapping component arguments to Tailwind utility classes
- Managing internal dismissed state with `@tracked`
- Controlled vs uncontrolled dismiss patterns
