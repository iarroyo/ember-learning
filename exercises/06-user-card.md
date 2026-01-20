# Exercise 06: User Card Component

**Difficulty: Medium**

## Objective
Create a user card component that displays user information with optional avatar, online status, and contact functionality.

## Requirements

Create a component at `app/components/user-card.gts` that:

1. Accepts a `@user` object with user details
2. Displays full name (firstName + lastName)
3. Shows avatar image if provided, otherwise shows initials
4. Displays email address
5. Shows online/offline status with appropriate styling
6. Shows a premium badge if the user is premium
7. Has a contact button that calls `@onContact` when clicked
8. Disables the contact button if no `@onContact` is provided

## Component Signature

```typescript
export interface User {
  firstName: string;
  lastName: string;
  email: string;
  isOnline: boolean;
  avatar?: string;
  isPremium?: boolean;
}

interface UserCardSignature {
  Args: {
    user: User;
    onContact?: (user: User) => void;
  };
  Element: HTMLDivElement;
}
```

## Data Test Attributes

- `[data-test-avatar]` - Avatar image (if provided)
- `[data-test-initials]` - Initials display (if no avatar)
- `[data-test-full-name]` - Full name display
- `[data-test-email]` - Email display
- `[data-test-status]` - Online/offline status indicator
- `[data-test-premium-badge]` - Premium badge (if applicable)
- `[data-test-contact-button]` - Contact action button

## Computed Properties

- `fullName`: Concatenates firstName and lastName
- `initials`: First letter of firstName and lastName, uppercased (e.g., "JD")
- `statusClass`: Returns "online" or "offline"
- `statusText`: Returns "Online" or "Offline"

## Usage Example

```handlebars
<UserCard
  @user={{hash
    firstName="John"
    lastName="Doe"
    email="john@example.com"
    isOnline=true
  }}
  @onContact={{this.handleContact}}
/>
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | user-card` pass.

## Learning Goals

- Creating computed getters from arguments
- Conditional rendering with `{{#if}}`
- Optional callback patterns
- Using helper functions like `not` for template logic
