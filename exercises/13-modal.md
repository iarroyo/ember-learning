# Exercise 13: Modal Component (Compound Pattern)

**Difficulty: Extreme**

## Objective

Create a fully accessible modal component using the compound component pattern with co-located subcomponents for Trigger, Header, Body, and Footer.

## Requirements

Create a single file at `app/components/modal.gts` containing:

- `Modal` - Main modal container (exported)
- `ModalTrigger` - Button to open modal (internal)
- `ModalHeader` - Modal header with title and close button (internal)
- `ModalBody` - Modal content area (internal)
- `ModalFooter` - Modal action buttons area (internal)

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
    default: [
      {
        Trigger: ComponentLike<ModalTriggerSignature>;
        Header: ComponentLike<ModalHeaderSignature>;
        Body: ComponentLike<ModalBodySignature>;
        Footer: ComponentLike<ModalFooterSignature>;
        close: () => void;
        isOpen: boolean;
      },
    ];
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

### File Structure

All components in a single file using co-location pattern:

```typescript
// Internal subcomponents
class ModalTrigger extends Component<ModalTriggerSignature> { ... }
const ModalHeader: TOC<ModalHeaderSignature> = <template>...</template>;
const ModalBody: TOC<ModalBodySignature> = <template>...</template>;
const ModalFooter: TOC<ModalFooterSignature> = <template>...</template>;

// Exported main component
export class Modal extends Component<ModalSignature> { ... }
```

### Modal (main)

- Manages open/close state (controlled or uncontrolled)
- Handles backdrop click
- Handles Escape key
- Stores trigger element reference for focus return
- Yields subcomponents via `{{component}}` helper with pre-bound args

### Trigger

- Button that opens modal
- Stores element reference when clicked for focus return

### Header

- Template-only component (TOC)
- Displays title with unique ID for aria-labelledby
- Has close button

### Body/Footer

- Template-only components that yield content

## Usage Example

```handlebars
<Modal as |modal|>
  <modal.Trigger>Open Modal</modal.Trigger>

  {{#if modal.isOpen}}
    <modal.Header @title='My Modal' />
    <modal.Body>
      <p>Modal content goes here</p>
    </modal.Body>
    <modal.Footer>
      <button {{on 'click' modal.close}}>Close</button>
    </modal.Footer>
  {{/if}}
</Modal>
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | modal` pass.

## Learning Goals

- Compound component pattern with co-located subcomponents
- Template-only components (TOC) for simple wrappers
- Yielding components with `{{component}}` helper and pre-bound arguments
- Using `ember-modifier` for DOM manipulation (focus management)
- Focus management and accessibility (aria attributes, keyboard handling)
- Controlled vs uncontrolled component patterns
