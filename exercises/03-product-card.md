# Exercise 03: Product Card Component

**Difficulty: Medium**

## Objective
Create a product card component that displays product information and integrates with a shopping cart service.

## Requirements

Create a component at `app/components/product-card.gts` that:

1. Accepts a `@product` argument with product details
2. Displays the product name, price, and optional image
3. Formats the price with a dollar sign and two decimal places (e.g., "$19.99")
4. Links to the product detail page at `/products/{id}`
5. Has an "Add to Cart" button that adds the product to the shopping cart

## Component Signature

```typescript
interface Product {
  id: string;
  name: string;
  price: number;
  image?: string;
}

interface ProductCardSignature {
  Args: {
    product: Product;
  };
  Element: HTMLDivElement;
}
```

## Data Test Attributes

- `[data-test-product-image]` - Product image (if provided)
- `[data-test-product-link]` - Link to product detail page
- `[data-test-product-name]` - Product name display
- `[data-test-product-price]` - Formatted price display
- `[data-test-add-to-cart]` - Add to cart button

## Usage Example

```handlebars
<ProductCard @product={{hash id="1" name="Widget" price=19.99}} />
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | product-card` pass.

## Learning Goals

- Injecting services with `@service`
- Computed getters for formatting data
- Calling service methods from actions
- Conditional rendering with `{{#if}}`
