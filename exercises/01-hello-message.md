# Exercise 01: Hello Message Component

**Difficulty: Low**

## Objective
Create a simple Glimmer component that displays a personalized greeting message.

## Requirements

Create a component at `app/components/hello-message.gts` that:

1. Accepts a `@name` argument
2. Displays "Hello, {name}!" where {name} is the provided argument
3. If no name is provided, displays "Hello, World!"

## Component Signature

```typescript
interface HelloMessageSignature {
  Args: {
    name?: string;
  };
  Element: HTMLDivElement;
}
```

## Usage Example

```handlebars
<HelloMessage @name="Alice" />
{{! Renders: Hello, Alice! }}

<HelloMessage />
{{! Renders: Hello, World! }}
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | hello-message` pass.

## Learning Goals

- Understanding Glimmer component structure
- Working with component arguments (`@args`)
- Using default values for optional arguments
- Basic template syntax with `.gts` files
