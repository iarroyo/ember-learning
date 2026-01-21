# Exercise 14: Protected Routes

**Difficulty: Difficult**

## Objective

Create a route structure with authentication guards that redirect unauthenticated users to login and handle post-login redirects.

## Requirements

Create routes:

- `app/routes/login.ts` - Login page route
- `app/routes/dashboard.ts` - Protected dashboard route
- `app/routes/products.ts` - Products list route
- `app/routes/products/product.ts` - Individual product route

Create templates:

- `app/templates/login.gts`
- `app/templates/dashboard.gts`
- `app/templates/products.gts`
- `app/templates/products/product.gts`

## Router Configuration

```typescript
// app/router.ts
Router.map(function () {
  this.route('login');
  this.route('dashboard');
  this.route('products', function () {
    this.route('product', { path: '/:product_id' });
  });
});
```

## Protected Route Pattern

```typescript
// app/routes/dashboard.ts
export default class DashboardRoute extends Route {
  @service declare session: SessionService;
  @service declare router: RouterService;

  beforeModel(transition: Transition): void {
    // Check for existing token in localStorage
    const token = localStorage.getItem('auth-token');
    if (token) {
      // Restore session from token
      // Set session.isAuthenticated = true
      return;
    }

    // Not authenticated - store transition and redirect
    this.session.attemptedTransition = transition;
    this.router.transitionTo('login');
  }
}
```

## Login Route Pattern

```typescript
// app/routes/login.ts
export default class LoginRoute extends Route {
  @service declare session: SessionService;

  beforeModel(): void {
    // If already authenticated, redirect to dashboard
    if (this.session.isAuthenticated) {
      this.router.transitionTo('dashboard');
    }
  }
}
```

## Post-Login Redirect

After successful login, check for `session.attemptedTransition` and retry it:

```typescript
if (this.session.attemptedTransition) {
  this.session.attemptedTransition.retry();
  this.session.attemptedTransition = null;
} else {
  this.router.transitionTo('dashboard');
}
```

## Template Requirements

### Login Template

- Renders `<LoginForm>` component
- Passes `@onSuccess` to handle redirect

### Dashboard Template

- Shows welcome message with user's name
- Has logout button

### Products Template

- Lists products
- Uses `{{outlet}}` for nested routes

### Product Template

- Shows individual product details

## Tests to Pass

Run `npm test` and ensure all tests in `Acceptance | authentication` pass.

## Learning Goals

- Route lifecycle hooks (`beforeModel`, `model`)
- Route guards and authentication
- Service injection in routes
- Transition handling and redirects
- Nested routes with `{{outlet}}`
- Using `@ember/routing/transition` type
