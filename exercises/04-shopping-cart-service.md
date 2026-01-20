# Exercise 04: Shopping Cart Service

**Difficulty: Medium**

## Objective
Create a service to manage shopping cart state across the application.

## Requirements

Create a service at `app/services/shopping-cart.ts` that:

1. Maintains a list of cart items with `@tracked` reactivity
2. Provides computed properties for item count, subtotal, and empty state
3. Supports adding items (with quantity tracking for duplicates)
4. Supports removing items by ID
5. Supports updating item quantities
6. Can clear the entire cart

## Service Interface

```typescript
export interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
}

export default class ShoppingCartService extends Service {
  @tracked items: CartItem[];

  get itemCount(): number;
  get subtotal(): number;
  get isEmpty(): boolean;

  addItem(product: { id: string; name: string; price: number }): void;
  removeItem(id: string): void;
  updateQuantity(id: string, quantity: number): void;
  clearCart(): void;
}
```

## Behavior Details

- `addItem`: If the item already exists, increment its quantity; otherwise add with quantity 1
- `updateQuantity`: If quantity is 0 or less, remove the item
- `itemCount`: Total number of items (sum of all quantities)
- `subtotal`: Sum of (price * quantity) for all items

## Usage Example

```typescript
// In a component
@service declare shoppingCart: ShoppingCartService;

addProduct() {
  this.shoppingCart.addItem({ id: '1', name: 'Widget', price: 19.99 });
}
```

## Tests to Pass

Run `npm test` and ensure all tests in `Unit | Service | shopping-cart` pass.

## Learning Goals

- Creating Ember services
- Using `@tracked` for reactive arrays
- Triggering reactivity when mutating arrays (spreading to create new arrays)
- Service injection pattern
