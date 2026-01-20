# Exercise 08: Session Service

**Difficulty: Difficult**

## Objective
Create a session service to manage user authentication state across the application.

## Requirements

Create a service at `app/services/session.ts` that:

1. Tracks authentication state (`isAuthenticated`)
2. Stores the current user object
3. Stores the authentication token
4. Provides login/logout methods
5. Can restore session from localStorage
6. Stores attempted transition for redirect after login

## Service Interface

```typescript
export interface User {
  email: string;
  name: string;
}

export default class SessionService extends Service {
  @tracked isAuthenticated: boolean;
  @tracked currentUser: User | null;
  @tracked token: string | null;
  attemptedTransition: Transition | null;

  async login(credentials: { email: string; password: string }): Promise<void>;
  logout(): void;
  async restoreSession(): Promise<void>;
}
```

## Behavior Details

### login(credentials)
- Validates credentials (mock: email="user@example.com", password="password123")
- On success: Set token, user, isAuthenticated; store token in localStorage
- On failure: Throw an error with message

### logout()
- Clear all auth state
- Remove token from localStorage

### restoreSession()
- Check localStorage for existing token
- Decode token to restore user info
- Handle invalid tokens gracefully

## Usage Example

```typescript
// In a component
@service declare session: SessionService;

async login() {
  await this.session.login({ email: this.email, password: this.password });
  // Handle success
}
```

## Tests to Pass

Run `npm test` and ensure all tests in `Unit | Service | session` pass.

## Learning Goals

- Managing authentication state
- Working with localStorage
- Async service methods
- Token-based authentication patterns
- Using `@ember/test-waiters` for async test synchronization
