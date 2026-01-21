# Exercise 05: Cart Summary Component

**Difficulty: Low**

## Objective

Create a component that displays a summary of the shopping cart by consuming the shopping cart service.

## Requirements

Create a component at `app/components/cart-summary.gts` that:

1. Displays the total item count from the cart
2. Displays the formatted subtotal (e.g., "$59.97")
3. Has a "Clear Cart" button that empties the cart
4. Disables the clear button when the cart is empty

## Component Signature

```typescript
interface CartSummarySignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}
```

## Data Test Attributes

- `[data-test-item-count]` - Total item count display
- `[data-test-subtotal]` - Formatted subtotal display
- `[data-test-clear-cart]` - Clear cart button

## Usage Example

```handlebars
<CartSummary />
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | cart-summary` pass.

## Learning Goals

- Consuming services in components
- Delegating to service methods
- Formatting numbers for display
- Conditional button states with `disabled`
