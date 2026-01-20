# Exercise 16: Cleanup Patterns and Destructors

**Difficulty: Difficult**

## Objective
Learn proper cleanup patterns in Ember to prevent memory leaks, including `registerDestructor`, modifier cleanup, and `isDestroying` checks for async operations.

## Why Cleanup Matters

Memory leaks occur when:
- Event listeners aren't removed
- Timers/intervals aren't cleared
- Async operations update destroyed components

## Three Cleanup Patterns

### 1. `registerDestructor` for Non-Component Classes

Use `registerDestructor` from `@ember/destroyable` when creating classes that need cleanup but aren't components:

```typescript
import { registerDestructor } from '@ember/destroyable';

class KeyboardShortcutManager {
  private handler: (e: KeyboardEvent) => void;

  constructor(owner: object, shortcuts: Map<string, () => void>) {
    this.handler = (e: KeyboardEvent) => {
      const callback = shortcuts.get(e.key);
      callback?.();
    };

    document.addEventListener('keydown', this.handler);

    // Register cleanup - runs when owner is destroyed
    registerDestructor(this, () => {
      document.removeEventListener('keydown', this.handler);
    });
  }
}
```

### 2. Modifier Cleanup (Return Function)

Modifiers can return a cleanup function that runs when the element is removed:

```typescript
import { modifier } from 'ember-modifier';

const onKeydown = modifier((element, [key, callback]: [string, () => void]) => {
  const handler = (e: KeyboardEvent) => {
    if (e.key === key) callback();
  };

  element.addEventListener('keydown', handler);

  // Return cleanup function
  return () => {
    element.removeEventListener('keydown', handler);
  };
});
```

### 3. `isDestroying` Check for Async Operations

Always check `this.isDestroying` before updating state after async operations:

```typescript
class MyComponent extends Component {
  @tracked data = null;

  async loadData() {
    const result = await fetch('/api/data');

    // Component may be destroyed while awaiting
    if (this.isDestroying) return;

    this.data = result;
  }
}
```

## Requirements

Create a keyboard shortcuts component at `app/components/keyboard-shortcuts.gts` that:

1. Accepts a `@shortcuts` argument (Map of key → callback)
2. Uses a `KeyboardShortcutManager` class with `registerDestructor`
3. Includes an `onGlobalKeydown` modifier for element-scoped shortcuts
4. Demonstrates `isDestroying` check in an async operation
5. Properly cleans up all listeners when destroyed

## Component Signature

```typescript
interface KeyboardShortcutsSignature {
  Args: {
    shortcuts: Map<string, () => void>;
    onInit?: () => Promise<void>;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}
```

## Implementation Structure

```typescript
// 1. Manager class with registerDestructor
class KeyboardShortcutManager {
  constructor(owner: object, shortcuts: Map<string, () => void>) {
    // Add global listener
    // Register destructor to remove listener
  }
}

// 2. Modifier with cleanup return
const onKeydown = modifier((element, [key, callback]) => {
  // Add listener
  return () => {
    // Remove listener (cleanup)
  };
});

// 3. Component with isDestroying check
export class KeyboardShortcuts extends Component {
  manager: KeyboardShortcutManager;

  constructor(owner, args) {
    super(owner, args);
    this.manager = new KeyboardShortcutManager(this, args.shortcuts);
    this.initialize();
  }

  async initialize() {
    if (this.args.onInit) {
      await this.args.onInit();
      if (this.isDestroying) return; // Don't update if destroyed
      // Safe to update state here
    }
  }
}
```

## Data Test Attributes

- `[data-test-keyboard-shortcuts]` - Container element
- `[data-test-shortcut-input]` - Input that responds to element-scoped shortcuts

## Usage Example

```typescript
// In a parent component
shortcuts = new Map([
  ['Escape', () => this.closeModal()],
  ['s', () => this.save()],
]);

<template>
  <KeyboardShortcuts @shortcuts={{this.shortcuts}}>
    <input
      data-test-shortcut-input
      {{onKeydown "Enter" this.submit}}
    />
  </KeyboardShortcuts>
</template>
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | keyboard-shortcuts` pass.

## Learning Goals

- Using `registerDestructor` from `@ember/destroyable` for custom class cleanup
- Returning cleanup functions from modifiers
- Checking `isDestroying` before updating state after async operations
- Understanding the Ember destroyable hierarchy
- Preventing memory leaks from event listeners
