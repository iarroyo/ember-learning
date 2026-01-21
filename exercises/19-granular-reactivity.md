# Exercise 19: Granular Reactivity

**Difficulty: Intermediate**

**Prerequisites:** Exercise 02 (Counter), Exercise 03 (Shopping Cart Service)

## Objective

Learn why using individual `@tracked` properties (granular reactivity) is preferred over a single tracked object that must be reassigned on every update.

## The Problem with Single Object Reactivity

A common anti-pattern is storing all state in a single tracked object:

```typescript
// ❌ Anti-pattern: Single reactive object
class ProfileEditor extends Component {
  @tracked state = {
    firstName: '',
    lastName: '',
    email: '',
    bio: '',
    saveCount: 0,
  };

  @action
  updateFirstName(event: Event) {
    const value = (event.target as HTMLInputElement).value;
    // Must reassign the ENTIRE object to trigger reactivity
    this.state = { ...this.state, firstName: value };
  }

  @action
  updateLastName(event: Event) {
    const value = (event.target as HTMLInputElement).value;
    this.state = { ...this.state, lastName: value };
  }

  // Every single update requires spreading and reassigning!
}
```

### Problems with this approach:

1. **Verbose updates** - Every change requires `{ ...this.state, field: value }`
2. **All consumers re-render** - Any component using `this.state` re-renders on ANY field change
3. **Performance overhead** - Creates a new object on every keystroke
4. **Easy to forget** - Mutating `this.state.firstName = value` silently fails to trigger updates
5. **Poor TypeScript inference** - Harder to track which fields are being used where

## The Solution: Granular Tracked Properties

```typescript
// ✅ Good pattern: Granular tracked properties
class ProfileEditor extends Component {
  @tracked firstName = '';
  @tracked lastName = '';
  @tracked email = '';
  @tracked bio = '';
  @tracked saveCount = 0;

  @action
  updateFirstName(event: Event) {
    this.firstName = (event.target as HTMLInputElement).value;
    // Simple, direct assignment - only firstName consumers re-render
  }

  // Derived state works naturally
  get fullName(): string {
    return `${this.firstName} ${this.lastName}`.trim();
  }

  get isValid(): boolean {
    return this.firstName.length > 0 && this.email.includes('@');
  }
}
```

### Benefits:

1. **Simple updates** - Direct assignment: `this.firstName = value`
2. **Targeted re-renders** - Only components using `firstName` re-render when it changes
3. **No object allocation** - No spreading, no new object creation
4. **Fail-fast** - Non-tracked properties obviously don't update the UI
5. **Better TypeScript** - Each property has clear types and usage tracking
6. **Natural derived state** - Getters automatically track their dependencies

## Requirements

Create `app/components/profile-editor.gts` that demonstrates both patterns side-by-side:

### Part 1: Anti-Pattern Version (for comparison)

Create a component that uses a single tracked object:

- Has `@tracked state` object with firstName, lastName, email, bio
- Updates require reassigning the entire object
- Shows a render counter to demonstrate re-renders

### Part 2: Granular Version (recommended)

Create a component with individual tracked properties:

- Has separate `@tracked` properties for each field
- Updates are simple direct assignments
- Shows a render counter to compare re-render behavior

### Part 3: Render Tracking

Both versions should:

- Display a "Render count" that increments each time the component's template is evaluated
- This helps visualize when re-renders occur

## Component Signature

```typescript
interface ProfileEditorSignature {
  Args: {
    mode: 'object' | 'granular';
    onSave?: (profile: ProfileData) => void;
  };
  Element: HTMLFormElement;
}

interface ProfileData {
  firstName: string;
  lastName: string;
  email: string;
  bio: string;
}
```

## Data Test Attributes

- `[data-test-profile-editor]` - Form container
- `[data-test-first-name]` - First name input
- `[data-test-last-name]` - Last name input
- `[data-test-email]` - Email input
- `[data-test-bio]` - Bio textarea
- `[data-test-full-name]` - Full name display (derived)
- `[data-test-render-count]` - Render count display
- `[data-test-save-button]` - Save button

## Usage Example

```handlebars
<div class='grid grid-cols-2 gap-8'>
  {{! Anti-pattern: Single object - notice render count increases on ANY field change }}
  <ProfileEditor @mode='object' />

  {{! Good pattern: Granular - more targeted re-renders }}
  <ProfileEditor @mode='granular' />
</div>
```

## Key Observations

When testing both modes:

1. **Type in firstName** - In "object" mode, the entire form re-renders. In "granular" mode, only firstName-dependent parts update.

2. **Type in email** - Same behavior difference.

3. **Derived state (`fullName`)** - In both modes, `fullName` updates when firstName or lastName changes, but in "granular" mode, changing email doesn't cause fullName to recalculate.

## When Single Objects ARE Appropriate

Single tracked objects can be appropriate when:

1. **The data comes from an API** - You receive a whole object and display it read-only
2. **All-or-nothing updates** - The entire object is always replaced (e.g., form reset)
3. **Deeply nested data** - Using `@tracked` with TrackedObject/TrackedArray from `tracked-built-ins`

```typescript
// OK: API response displayed read-only
@tracked user: User | null = null;

async loadUser() {
  this.user = await this.api.fetchUser();
}

// OK: Form reset replaces everything
@action
resetForm() {
  this.formData = { ...this.initialData };
}
```

## Tests to Pass

Run `npm test` and ensure all tests in:

- `Integration | Component | profile-editor`

## Learning Goals

- Understanding why granular `@tracked` properties are preferred
- Recognizing the performance implications of object reassignment
- Knowing when single tracked objects are acceptable
- Using derived getters that depend on specific tracked properties
- Visualizing re-render behavior with render counters
