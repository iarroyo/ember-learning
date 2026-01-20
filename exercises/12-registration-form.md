# Exercise 12: Registration Form Component

**Difficulty: Difficult**

## Objective
Create a registration form with comprehensive validation, password strength indicator, and touched-state tracking.

## Requirements

Create a component at `app/components/registration-form.gts` that:

1. Has fields: username, email, password, confirm password
2. Validates each field with specific rules
3. Only shows errors after field is "touched" (blurred)
4. Shows password strength indicator (Weak/Medium/Strong)
5. Has submit and clear buttons
6. Disables submit until form is valid
7. Shows success message after submission

## Component Signature

```typescript
interface RegistrationFormSignature {
  Args: {
    onSubmit?: (data: {
      username: string;
      email: string;
      password: string;
    }) => void;
  };
  Element: HTMLFormElement;
}
```

## Data Test Attributes

- `[data-test-username-input]` - Username input
- `[data-test-username-error]` - Username error message
- `[data-test-email-input]` - Email input
- `[data-test-email-error]` - Email error message
- `[data-test-password-input]` - Password input
- `[data-test-password-error]` - Password error message
- `[data-test-password-strength]` - Password strength indicator
- `[data-test-confirm-password-input]` - Confirm password input
- `[data-test-confirm-password-error]` - Confirm password error message
- `[data-test-submit-button]` - Submit button
- `[data-test-clear-button]` - Clear/reset button
- `[data-test-success-message]` - Success message

## Validation Rules

### Username
- Minimum 3 characters
- Only alphanumeric characters and underscores

### Email
- Must match email pattern: `^[^\s@]+@[^\s@]+\.[^\s@]+$`

### Password
- Minimum 8 characters
- Must contain at least one uppercase letter
- Must contain at least one number

### Confirm Password
- Must match password field

## Password Strength Logic

- **Weak**: Doesn't meet basic requirements OR meets basics but 8-10 chars without special chars
- **Medium**: 11+ chars OR has special characters (and meets basic requirements)
- **Strong**: 12+ chars AND has special characters

## Usage Example

```handlebars
<RegistrationForm @onSubmit={{this.handleRegistration}} />
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | registration-form` pass.

## Learning Goals

- Complex form validation patterns
- Touched-state tracking for better UX
- Multiple computed getters with dependencies
- Password strength algorithms
- Form reset functionality
