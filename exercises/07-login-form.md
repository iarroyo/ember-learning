# Exercise 07: Login Form Component

**Difficulty: Medium**

## Objective

Create a login form component that handles user authentication through a session service.

## Requirements

Create a component at `app/components/login-form.gts` that:

1. Has email and password input fields
2. Tracks loading state during login
3. Displays error messages on failed login
4. Disables submit when form is invalid (empty fields)
5. Calls session service's login method
6. Invokes optional `@onSuccess` callback after successful login

## Component Signature

```typescript
interface LoginFormSignature {
  Args: {
    onSuccess?: () => void;
  };
  Element: HTMLFormElement;
}
```

## Data Test Attributes

- `[data-test-email-input]` - Email input field
- `[data-test-password-input]` - Password input field
- `[data-test-loading]` - Loading indicator
- `[data-test-error]` - Error message display
- `[data-test-submit-button]` - Submit button

## Tracked State

- `email`: Current email input value
- `password`: Current password input value
- `isLoading`: Whether login is in progress
- `error`: Error message from failed login attempt

## Behavior Details

1. Form validation: Both email and password must have content
2. On submit: Prevent default, set loading state, call session.login
3. On success: Call onSuccess if provided
4. On error: Display the error message
5. Always reset loading state after login attempt

## Usage Example

```handlebars
<LoginForm @onSuccess={{this.redirectToDashboard}} />
```

## Tests to Pass

Run `npm test` and ensure all tests in `Integration | Component | login-form` pass.

## Learning Goals

- Handling form submissions with `{{on "submit"}}`
- Managing async operations with loading states
- Error handling in async actions
- Two-way data binding with input events
