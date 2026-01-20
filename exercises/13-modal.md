# Exercise 13: Modal Component (Compound Pattern)

**Difficulty: Extreme**

## Objective
Create a fully accessible modal component using the compound component pattern with subcomponents for Trigger, Header, Body, and Footer.

## Requirements

Create components:
- `app/components/modal.gts` - Main modal container
- `app/components/modal/trigger.gts` - Button to open modal
- `app/components/modal/header.gts` - Modal header with title and close button
- `app/components/modal/body.gts` - Modal content area
- `app/components/modal/footer.gts` - Modal action buttons area

## Main Modal Signature

```typescript
interface ModalSignature {
  Args: {
    isOpen?: boolean;
    size?: 'sm' | 'md' | 'lg';
    closeOnBackdropClick?: boolean;
    onClose?: () => void;
  };
  Blocks: {
    default: [{
      Trigger: ComponentLike<ModalTriggerSignature>;
      Header: ComponentLike<ModalHeaderSignature>;
      Body: ComponentLike<ModalBodySignature>;
      Footer: ComponentLike<ModalFooterSignature>;
      close: () => void;
      isOpen: boolean;
    }];
  };
  Element: HTMLDivElement;
}
```

## Data Test Attributes

- `[data-test-modal]` - Modal container
- `[data-test-modal-backdrop]` - Backdrop overlay
- `[data-test-modal-content]` - Content container
- `[data-test-modal-trigger]` - Trigger button
- `[data-test-modal-header]` - Header section
- `[data-test-modal-title]` - Title text
- `[data-test-modal-close]` - Close button
- `[data-test-modal-body]` - Body section
- `[data-test-modal-footer]` - Footer section

## Accessibility Requirements

1. `role="dialog"` and `aria-modal="true"`
2. `aria-labelledby` pointing to title ID
3. Focus moves to modal on open (use ember-modifier)
4. Focus returns to trigger on close
5. Escape key closes modal

## Implementation Details

### Modal (main)
- Manages open/close state (controlled or uncontrolled)
- Handles backdrop click
- Handles Escape key
- Stores trigger element reference for focus return

### Trigger
- Button that opens modal
- Stores element reference when clicked
- Spreads `...attributes` for test selectors

### Header
- Displays title with unique ID for aria-labelledby
- Has close button

### Body/Footer
- Simple wrapper components that yield content

## Usage Example

```handlebars
<Modal as |modal|>
  <modal.Trigger>Open Modal</modal.Trigger>

  {{#if modal.isOpen}}
    <modal.Header @title="My Modal" />
    <modal.Body>
      <p>Modal content goes here</p>
    </modal.Body>
    <modal.Footer>
      <button {{on "click" modal.close}}>Close</button>
    </modal.Footer>
  {{/if}}
</Modal>
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | modal` pass.

## Learning Goals

- Compound component pattern
- Yielding components with `{{let}}` and `{{component}}`
- Using ember-modifier for DOM manipulation
- Focus management and accessibility
- Controlled vs uncontrolled component patterns
