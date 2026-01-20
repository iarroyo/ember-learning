# ember-learning

A hands-on learning project for Ember.js featuring 19 exercises that cover routing, components, services, testing, and modern Ember patterns.

## Learning Goals

This project covers the following topics, organized by category:

### Components & Templates

| Goal | Exercise |
|------|----------|
| Glimmer component structure with `.gts` files | 01 - Hello Message |
| Component arguments (`@args`) and default values | 01, 02, 06 |
| `@tracked` for reactive state | 02, 03, 15 |
| `@cached` for expensive derived computations | 03 - Shopping Cart Service |
| Computed getters for derived data | 04, 06, 12, 15 |
| Conditional rendering (`{{#if}}`, `{{#each}}`) | 04, 06, 09 |
| Event handling (`{{on "click"}}`, `@action`) | 02, 07 |
| Generic/reusable component patterns | 10 - Data Fetcher |
| Yielding data to blocks | 10, 13 |
| Compound component pattern | 13 - Modal |
| Template-only components (TOC) | 13 - Modal |
| Controlled vs uncontrolled patterns | 13, 15 |
| Granular reactivity vs single object state | 19 - Granular Reactivity |

### Services & State Management

| Goal | Exercise |
|------|----------|
| Creating and using services | 03 - Shopping Cart Service |
| Service injection with `@service` | 04, 05, 07, 14 |
| Reactive arrays (triggering updates) | 03 - Shopping Cart Service |
| Authentication state management | 08 - Session Service |
| Token-based auth with localStorage | 08 - Session Service |
| Sharing state across components via services | 18 - Ember Concurrency |

### Forms & Validation

| Goal | Exercise |
|------|----------|
| Form submission handling | 07 - Login Form |
| Two-way data binding with inputs | 07, 12 |
| Async operations with loading states | 07, 09, 17 |
| Error handling in async actions | 07, 09 |
| Complex form validation patterns | 12 - Registration Form |
| Touched-state tracking for UX | 12 - Registration Form |
| Password strength algorithms | 12 - Registration Form |

### Routing & Navigation

| Goal | Exercise |
|------|----------|
| Route lifecycle hooks (`beforeModel`, `model`) | 14 - Protected Routes |
| Route guards and authentication | 14 - Protected Routes |
| Transition handling and redirects | 14 - Protected Routes |
| Nested routes with `{{outlet}}` | 14 - Protected Routes |

### Async Patterns

| Goal | Exercise |
|------|----------|
| Managing loading/error/success states | 09, 10, 11 |
| AbortController for request cancellation | 11 - Async Resource |
| `ember-concurrency` tasks | 18 - Ember Concurrency |
| Task modifiers (`restartable`, `drop`, etc.) | 18 - Ember Concurrency |
| `lastSuccessful` stale-while-revalidate pattern | 18 - Ember Concurrency |
| Task instance independence per component | 18 - Ember Concurrency |

### Testing

| Goal | Exercise |
|------|----------|
| `@ember/test-waiters` for async synchronization | 08, 17 |
| `waitForPromise` for simple async wrapping | 17 - Test Waiters |
| `buildWaiter` with `beginAsync`/`endAsync` | 17 - Test Waiters |
| Preventing flaky tests from race conditions | 17 - Test Waiters |
| Testing loading/success/error states | 17 - Test Waiters |

### Lifecycle & Cleanup

| Goal | Exercise |
|------|----------|
| Component lifecycle (`willDestroy`) | 10 - Data Fetcher |
| `registerDestructor` for custom cleanup | 16 - Cleanup Patterns |
| Modifier cleanup functions | 16 - Cleanup Patterns |
| `isDestroying` checks for async operations | 16 - Cleanup Patterns |
| Preventing memory leaks from listeners | 16 - Cleanup Patterns |
| Automatic cleanup with ember-concurrency | 18 - Ember Concurrency |

### DOM & Accessibility

| Goal | Exercise |
|------|----------|
| Focus management | 13 - Modal |
| ARIA attributes for accessibility | 13 - Modal |
| Keyboard event handling | 13, 16 |
| Using modifiers for DOM manipulation | 13, 16 |

## Exercises Overview

| # | Exercise | Key Concepts |
|---|----------|--------------|
| 01 | Hello Message | Components, Arguments, Templates |
| 02 | Counter | @tracked, Actions, Events |
| 03 | Shopping Cart Service | Services, @tracked arrays, @cached |
| 04 | Product Card | Service injection, Computed getters |
| 05 | Cart Summary | Consuming services, Formatting |
| 06 | User Card | Conditional rendering, Optional callbacks |
| 07 | Login Form | Form handling, Async operations |
| 08 | Session Service | Auth state, localStorage, Test waiters |
| 09 | User List | Component composition, Async states |
| 10 | Data Fetcher | Generic components, Yielding, Lifecycle |
| 11 | Async Resource | Utility classes, AbortController |
| 12 | Registration Form | Complex validation, Password strength |
| 13 | Modal | Compound components, Focus management |
| 14 | Protected Routes | Route guards, Transitions |
| 15 | Alert | Declarative styling, @tracked vs lifecycle |
| 16 | Cleanup Patterns | registerDestructor, Modifier cleanup |
| 17 | Test Waiters | waitForPromise, buildWaiter |
| 18 | Ember Concurrency | Tasks, lastSuccessful, Shared tasks |
| 19 | Granular Reactivity | @tracked properties vs object reassignment |

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
