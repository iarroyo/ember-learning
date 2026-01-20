# ember-learning

A hands-on learning project for Ember.js featuring 19 exercises that cover routing, components, services, testing, and modern Ember patterns.

## Learning Goals

This project covers the following topics, organized by category:

### Components & Templates

| Goal | Exercise |
|------|----------|
| Glimmer component structure with `.gts` files | [01 - Hello Message](exercises/01-hello-message.md) |
| Component arguments (`@args`) and default values | [01](exercises/01-hello-message.md), [02](exercises/02-counter.md), [06](exercises/06-user-card.md) |
| `@tracked` for reactive state | [02](exercises/02-counter.md), [03](exercises/03-shopping-cart-service.md), [15](exercises/15-alert.md) |
| `@cached` for expensive derived computations | [03 - Shopping Cart Service](exercises/03-shopping-cart-service.md) |
| Computed getters for derived data | [04](exercises/04-product-card.md), [06](exercises/06-user-card.md), [12](exercises/12-registration-form.md), [15](exercises/15-alert.md) |
| Conditional rendering (`{{#if}}`, `{{#each}}`) | [04](exercises/04-product-card.md), [06](exercises/06-user-card.md), [09](exercises/09-user-list.md) |
| Event handling (`{{on "click"}}`, `@action`) | [02](exercises/02-counter.md), [07](exercises/07-login-form.md) |
| Generic/reusable component patterns | [10 - Data Fetcher](exercises/10-data-fetcher.md) |
| Yielding data to blocks | [10](exercises/10-data-fetcher.md), [13](exercises/13-modal.md) |
| Compound component pattern | [13 - Modal](exercises/13-modal.md) |
| Template-only components (TOC) | [13 - Modal](exercises/13-modal.md) |
| Controlled vs uncontrolled patterns | [13](exercises/13-modal.md), [15](exercises/15-alert.md) |
| Granular reactivity vs single object state | [19 - Granular Reactivity](exercises/19-granular-reactivity.md) |

### Services & State Management

| Goal | Exercise |
|------|----------|
| Creating and using services | [03 - Shopping Cart Service](exercises/03-shopping-cart-service.md) |
| Service injection with `@service` | [04](exercises/04-product-card.md), [05](exercises/05-cart-summary.md), [07](exercises/07-login-form.md), [14](exercises/14-protected-routes.md) |
| Reactive arrays (triggering updates) | [03 - Shopping Cart Service](exercises/03-shopping-cart-service.md) |
| Authentication state management | [08 - Session Service](exercises/08-session-service.md) |
| Token-based auth with localStorage | [08 - Session Service](exercises/08-session-service.md) |
| Sharing state across components via services | [18 - Ember Concurrency](exercises/18-ember-concurrency.md) |

### Forms & Validation

| Goal | Exercise |
|------|----------|
| Form submission handling | [07 - Login Form](exercises/07-login-form.md) |
| Two-way data binding with inputs | [07](exercises/07-login-form.md), [12](exercises/12-registration-form.md) |
| Async operations with loading states | [07](exercises/07-login-form.md), [09](exercises/09-user-list.md), [17](exercises/17-test-waiters.md) |
| Error handling in async actions | [07](exercises/07-login-form.md), [09](exercises/09-user-list.md) |
| Complex form validation patterns | [12 - Registration Form](exercises/12-registration-form.md) |
| Touched-state tracking for UX | [12 - Registration Form](exercises/12-registration-form.md) |
| Password strength algorithms | [12 - Registration Form](exercises/12-registration-form.md) |

### Routing & Navigation

| Goal | Exercise |
|------|----------|
| Route lifecycle hooks (`beforeModel`, `model`) | [14 - Protected Routes](exercises/14-protected-routes.md) |
| Route guards and authentication | [14 - Protected Routes](exercises/14-protected-routes.md) |
| Transition handling and redirects | [14 - Protected Routes](exercises/14-protected-routes.md) |
| Nested routes with `{{outlet}}` | [14 - Protected Routes](exercises/14-protected-routes.md) |

### Async Patterns

| Goal | Exercise |
|------|----------|
| Managing loading/error/success states | [09](exercises/09-user-list.md), [10](exercises/10-data-fetcher.md), [11](exercises/11-async-resource.md) |
| AbortController for request cancellation | [11 - Async Resource](exercises/11-async-resource.md) |
| `ember-concurrency` tasks | [18 - Ember Concurrency](exercises/18-ember-concurrency.md) |
| Task modifiers (`restartable`, `drop`, etc.) | [18 - Ember Concurrency](exercises/18-ember-concurrency.md) |
| `lastSuccessful` stale-while-revalidate pattern | [18 - Ember Concurrency](exercises/18-ember-concurrency.md) |
| Task instance independence per component | [18 - Ember Concurrency](exercises/18-ember-concurrency.md) |

### Testing

| Goal | Exercise |
|------|----------|
| `@ember/test-waiters` for async synchronization | [08](exercises/08-session-service.md), [17](exercises/17-test-waiters.md) |
| `waitForPromise` for simple async wrapping | [17 - Test Waiters](exercises/17-test-waiters.md) |
| `buildWaiter` with `beginAsync`/`endAsync` | [17 - Test Waiters](exercises/17-test-waiters.md) |
| Preventing flaky tests from race conditions | [17 - Test Waiters](exercises/17-test-waiters.md) |
| Testing loading/success/error states | [17 - Test Waiters](exercises/17-test-waiters.md) |

### Lifecycle & Cleanup

| Goal | Exercise |
|------|----------|
| Component lifecycle (`willDestroy`) | [10 - Data Fetcher](exercises/10-data-fetcher.md) |
| `registerDestructor` for custom cleanup | [16 - Cleanup Patterns](exercises/16-cleanup-patterns.md) |
| Modifier cleanup functions | [16 - Cleanup Patterns](exercises/16-cleanup-patterns.md) |
| `isDestroying` checks for async operations | [16 - Cleanup Patterns](exercises/16-cleanup-patterns.md) |
| Preventing memory leaks from listeners | [16 - Cleanup Patterns](exercises/16-cleanup-patterns.md) |
| Automatic cleanup with ember-concurrency | [18 - Ember Concurrency](exercises/18-ember-concurrency.md) |

### DOM & Accessibility

| Goal | Exercise |
|------|----------|
| Focus management | [13 - Modal](exercises/13-modal.md) |
| ARIA attributes for accessibility | [13 - Modal](exercises/13-modal.md) |
| Keyboard event handling | [13](exercises/13-modal.md), [16](exercises/16-cleanup-patterns.md) |
| Using modifiers for DOM manipulation | [13](exercises/13-modal.md), [16](exercises/16-cleanup-patterns.md) |

## Exercises Overview

| # | Exercise | Key Concepts |
|---|----------|--------------|
| 01 | [Hello Message](exercises/01-hello-message.md) | Components, Arguments, Templates |
| 02 | [Counter](exercises/02-counter.md) | @tracked, Actions, Events |
| 03 | [Shopping Cart Service](exercises/03-shopping-cart-service.md) | Services, @tracked arrays, @cached |
| 04 | [Product Card](exercises/04-product-card.md) | Service injection, Computed getters |
| 05 | [Cart Summary](exercises/05-cart-summary.md) | Consuming services, Formatting |
| 06 | [User Card](exercises/06-user-card.md) | Conditional rendering, Optional callbacks |
| 07 | [Login Form](exercises/07-login-form.md) | Form handling, Async operations |
| 08 | [Session Service](exercises/08-session-service.md) | Auth state, localStorage, Test waiters |
| 09 | [User List](exercises/09-user-list.md) | Component composition, Async states |
| 10 | [Data Fetcher](exercises/10-data-fetcher.md) | Generic components, Yielding, Lifecycle |
| 11 | [Async Resource](exercises/11-async-resource.md) | Utility classes, AbortController |
| 12 | [Registration Form](exercises/12-registration-form.md) | Complex validation, Password strength |
| 13 | [Modal](exercises/13-modal.md) | Compound components, Focus management |
| 14 | [Protected Routes](exercises/14-protected-routes.md) | Route guards, Transitions |
| 15 | [Alert](exercises/15-alert.md) | Declarative styling, @tracked vs lifecycle |
| 16 | [Cleanup Patterns](exercises/16-cleanup-patterns.md) | registerDestructor, Modifier cleanup |
| 17 | [Test Waiters](exercises/17-test-waiters.md) | waitForPromise, buildWaiter |
| 18 | [Ember Concurrency](exercises/18-ember-concurrency.md) | Tasks, lastSuccessful, Shared tasks |
| 19 | [Granular Reactivity](exercises/19-granular-reactivity.md) | @tracked properties vs object reassignment |

## Prerequisites

You will need the following things properly installed on your computer.

- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/) (with npm)
- [Google Chrome](https://google.com/chrome/)

### Hello World Ember

Before proceeding with the exercises, complete the [Ember Tutorial](https://guides.emberjs.com/release/tutorial/) and ensure you are familiar with the following concepts:

#### Required Knowledge

**TypeScript & Tooling**
- [TypeScript](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes.html) - Basic TypeScript knowledge (types, interfaces, generics)
- [Glint](https://typed-ember.gitbook.io/glint) - Type-checked Glimmer templates

**Ember Core**
- [Routing](https://guides.emberjs.com/release/routing/)
- [Controllers](https://guides.emberjs.com/release/routing/controllers/) (setupController hook, controllerFor)
- [Services](https://guides.emberjs.com/release/services/)

**Components & Templates**
- [Components](https://guides.emberjs.com/release/components/) - Glimmer components with `.gts` template tag syntax
- [Component Arguments](https://guides.emberjs.com/release/components/component-arguments-and-html-attributes/) - `@args` and signatures
- [@tracked](https://guides.emberjs.com/release/components/component-state-and-actions/) - Reactive state with `@glimmer/tracking`
- [Modifiers](https://guides.emberjs.com/release/components/template-lifecycle-dom-and-modifiers/)
- [Helpers](https://guides.emberjs.com/release/components/helper-functions/) ([plain old functions as helpers](https://blog.emberjs.com/plain-old-functions-as-helpers/))

**Testing**
- [Testing](https://guides.emberjs.com/release/testing/)
  - [Ember test waiters](https://github.com/emberjs/ember-test-waiters)
  - [Ember test helpers](https://github.com/emberjs/ember-test-helpers)

#### Introduced in Exercises

These concepts are taught within the exercises themselves:
- `@cached` decorator for expensive computations (Exercise 03)
- `registerDestructor` from `@ember/destroyable` (Exercise 16)
- `ember-concurrency` tasks (Exercise 18)

## Installation

- `git clone <repository-url>` this repository
- `cd ember-learning`
- `npm install`

## Running / Development

- `npm run start`
- Visit your app at [http://localhost:4200](http://localhost:4200).
- Visit your tests at [http://localhost:4200/tests](http://localhost:4200/tests).

### Code Generators

Make use of the many generators for code, try `npm exec ember help generate` for more details

### Running Tests

- `npm run test`

### Linting

- `npm run lint`
- `npm run lint:fix`

### Building

- `npm exec vite build --mode development` (development)
- `npm run build` (production)

## Further Reading / Useful Links

- [ember.js](https://emberjs.com/)
- [Vite](https://vite.dev)
- Development Browser Extensions
  - [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  - [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)
