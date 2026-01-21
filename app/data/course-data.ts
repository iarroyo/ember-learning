/**
 * Course data - Single source of truth for exercises, prerequisites, and learning categories.
 * This data is used by the landing page and should be kept in sync with README.md.
 */

export interface Exercise {
  number: string;
  title: string;
  concepts: string;
  slug: string;
}

export interface Prerequisite {
  label: string;
  url: string;
}

export interface PrerequisiteCategory {
  title: string;
  icon: string;
  iconBg: string;
  iconColor: string;
  items: Prerequisite[];
}

export interface LearningCategory {
  title: string;
  titleColor: string;
  titleBg: string;
  items: string[];
}

export const exercises: Exercise[] = [
  {
    number: '01',
    title: 'Hello Message',
    slug: 'hello-message',
    concepts: 'Components, Arguments, Templates',
  },
  {
    number: '02',
    title: 'Counter',
    slug: 'counter',
    concepts: '@tracked, Actions, Events',
  },
  {
    number: '03',
    title: 'Shopping Cart Service',
    slug: 'shopping-cart-service',
    concepts: 'Services, @tracked arrays, @cached',
  },
  {
    number: '04',
    title: 'Product Card',
    slug: 'product-card',
    concepts: 'Service injection, Computed getters',
  },
  {
    number: '05',
    title: 'Cart Summary',
    slug: 'cart-summary',
    concepts: 'Consuming services, Formatting',
  },
  {
    number: '06',
    title: 'User Card',
    slug: 'user-card',
    concepts: 'Conditional rendering, Optional callbacks',
  },
  {
    number: '07',
    title: 'Login Form',
    slug: 'login-form',
    concepts: 'Form handling, Async operations',
  },
  {
    number: '08',
    title: 'Session Service',
    slug: 'session-service',
    concepts: 'Auth state, localStorage, Test waiters',
  },
  {
    number: '09',
    title: 'User List',
    slug: 'user-list',
    concepts: 'Component composition, Async states',
  },
  {
    number: '10',
    title: 'Data Fetcher',
    slug: 'data-fetcher',
    concepts: 'Generic components, Yielding, Lifecycle',
  },
  {
    number: '11',
    title: 'Async Resource',
    slug: 'async-resource',
    concepts: 'Utility classes, AbortController',
  },
  {
    number: '12',
    title: 'Registration Form',
    slug: 'registration-form',
    concepts: 'Complex validation, Password strength',
  },
  {
    number: '13',
    title: 'Modal',
    slug: 'modal',
    concepts: 'Compound components, Focus management',
  },
  {
    number: '14',
    title: 'Protected Routes',
    slug: 'protected-routes',
    concepts: 'Route guards, Transitions',
  },
  {
    number: '15',
    title: 'Alert',
    slug: 'alert',
    concepts: 'Declarative styling, @tracked vs lifecycle',
  },
  {
    number: '16',
    title: 'Cleanup Patterns',
    slug: 'cleanup-patterns',
    concepts: 'registerDestructor, Modifier cleanup',
  },
  {
    number: '17',
    title: 'Test Waiters',
    slug: 'test-waiters',
    concepts: 'waitForPromise, buildWaiter',
  },
  {
    number: '18',
    title: 'Ember Concurrency',
    slug: 'ember-concurrency',
    concepts: 'Tasks, lastSuccessful, Shared tasks',
  },
  {
    number: '19',
    title: 'Granular Reactivity',
    slug: 'granular-reactivity',
    concepts: '@tracked properties vs object reassignment',
  },
];

export const prerequisites: PrerequisiteCategory[] = [
  {
    title: 'TypeScript & Tooling',
    icon: 'TS',
    iconBg: 'bg-blue-100',
    iconColor: 'text-blue-600',
    items: [
      {
        label: 'Basic TypeScript (types, interfaces, generics)',
        url: 'https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes.html',
      },
      {
        label: 'Glint for type-checked templates',
        url: 'https://typed-ember.gitbook.io/glint',
      },
    ],
  },
  {
    title: 'Ember Core',
    icon: 'E',
    iconBg: 'bg-orange-100',
    iconColor: 'text-orange-600',
    items: [
      { label: 'Routing', url: 'https://guides.emberjs.com/release/routing/' },
      {
        label: 'Controllers',
        url: 'https://guides.emberjs.com/release/routing/controllers/',
      },
      {
        label: 'Services',
        url: 'https://guides.emberjs.com/release/services/',
      },
    ],
  },
  {
    title: 'Components & Templates',
    icon: 'C',
    iconBg: 'bg-emerald-100',
    iconColor: 'text-emerald-600',
    items: [
      {
        label: 'Glimmer components with .gts syntax',
        url: 'https://guides.emberjs.com/release/components/',
      },
      {
        label: 'Component arguments (@args)',
        url: 'https://guides.emberjs.com/release/components/component-arguments-and-html-attributes/',
      },
      {
        label: '@tracked state',
        url: 'https://guides.emberjs.com/release/components/component-state-and-actions/',
      },
      {
        label: 'Modifiers',
        url: 'https://guides.emberjs.com/release/components/template-lifecycle-dom-and-modifiers/',
      },
      {
        label: 'Helpers',
        url: 'https://guides.emberjs.com/release/components/helper-functions/',
      },
    ],
  },
  {
    title: 'Testing',
    icon: 'T',
    iconBg: 'bg-violet-100',
    iconColor: 'text-violet-600',
    items: [
      {
        label: 'Ember test helpers',
        url: 'https://github.com/emberjs/ember-test-helpers',
      },
      {
        label: 'Ember test waiters',
        url: 'https://github.com/emberjs/ember-test-waiters',
      },
    ],
  },
];

export const learningCategories: LearningCategory[] = [
  {
    title: 'Components & Templates',
    titleColor: 'text-emerald-600',
    titleBg: 'bg-emerald-100',
    items: [
      'Glimmer component structure with .gts files',
      'Component arguments (@args) and default values',
      '@tracked for reactive state',
      'Computed getters for derived data',
      'Conditional rendering and event handling',
    ],
  },
  {
    title: 'Services & State',
    titleColor: 'text-orange-600',
    titleBg: 'bg-orange-100',
    items: [
      'Creating and using services',
      'Service injection with @service',
      'Reactive arrays (triggering updates)',
      'Authentication state management',
      'Sharing state across components',
    ],
  },
  {
    title: 'Forms & Validation',
    titleColor: 'text-blue-600',
    titleBg: 'bg-blue-100',
    items: [
      'Form submission handling',
      'Two-way data binding with inputs',
      'Async operations with loading states',
      'Complex form validation patterns',
    ],
  },
  {
    title: 'Async Patterns',
    titleColor: 'text-amber-600',
    titleBg: 'bg-amber-100',
    items: [
      'Loading/error/success states',
      'AbortController for request cancellation',
      'ember-concurrency tasks',
      'Task modifiers (restartable, drop)',
      'lastSuccessful stale-while-revalidate',
    ],
  },
  {
    title: 'Testing',
    titleColor: 'text-violet-600',
    titleBg: 'bg-violet-100',
    items: [
      '@ember/test-waiters for async sync',
      'waitForPromise for async wrapping',
      'buildWaiter with beginAsync/endAsync',
      'Preventing flaky tests',
      'Testing loading/success/error states',
    ],
  },
  {
    title: 'Lifecycle & Cleanup',
    titleColor: 'text-rose-600',
    titleBg: 'bg-rose-100',
    items: [
      'Component lifecycle (willDestroy)',
      'registerDestructor for custom cleanup',
      'Modifier cleanup functions',
      'isDestroying checks for async',
      'Automatic cleanup with ember-concurrency',
    ],
  },
];

export const techStack = [
  'Ember.js',
  'TypeScript',
  'Glint',
  'Tailwind CSS',
  'ember-concurrency',
  'Vite',
];

export const links = {
  emberTutorial: 'https://guides.emberjs.com/release/tutorial/',
  github: 'https://github.com/iarroyo/ember-learning',
};
