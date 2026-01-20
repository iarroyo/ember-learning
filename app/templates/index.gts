import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

import { Alert } from 'ember-learning/components/alert';
import { AsyncButton } from 'ember-learning/components/async-button';
import { SearchBox } from 'ember-learning/components/search-box';
import { GlobalSearchBox } from 'ember-learning/components/global-search-box';
import { Counter } from 'ember-learning/components/counter';

class DemoPage extends Component {
  @tracked alertVariant: 'info' | 'success' | 'warning' | 'error' = 'info';
  @tracked asyncButtonState = 'idle';
  @tracked searchResults: string[] = [];
  @tracked showTaskDemo = false;

  @action
  setAlertVariant(variant: 'info' | 'success' | 'warning' | 'error'): void {
    this.alertVariant = variant;
  }

  @action
  async simulateAsync(): Promise<void> {
    this.asyncButtonState = 'loading';
    await new Promise((resolve) => setTimeout(resolve, 1500));
    this.asyncButtonState = 'success';
  }

  @action
  async simulateError(): Promise<void> {
    throw new Error('Simulated error');
  }

  @action
  toggleTaskDemo(): void {
    this.showTaskDemo = !this.showTaskDemo;
  }

  <template>
    <div class="max-w-6xl mx-auto px-4 py-8">
      {{! Header }}
      <header class="text-center mb-12">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">
          Ember Learning Project
        </h1>
        <p class="text-xl text-gray-600 max-w-2xl mx-auto">
          A collection of exercises and component implementations demonstrating modern Ember.js patterns including Glimmer components, tracked properties, services, and ember-concurrency.
        </p>
      </header>

      {{! Exercises Overview }}
      <section class="mb-12">
        <h2 class="text-2xl font-semibold text-gray-800 mb-6 border-b pb-2">
          Exercises Overview
        </h2>
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div class="bg-white p-4 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900">01-03: Basics</h3>
            <p class="text-sm text-gray-600">Components, Templates, Arguments</p>
          </div>
          <div class="bg-white p-4 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900">04-06: State & Services</h3>
            <p class="text-sm text-gray-600">Shopping Cart, @tracked, Services</p>
          </div>
          <div class="bg-white p-4 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900">07-09: Actions & Forms</h3>
            <p class="text-sm text-gray-600">Event Handling, Form Validation</p>
          </div>
          <div class="bg-white p-4 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900">10-12: Routing & Data</h3>
            <p class="text-sm text-gray-600">Routes, Models, Async Data</p>
          </div>
          <div class="bg-white p-4 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900">13-15: Advanced Patterns</h3>
            <p class="text-sm text-gray-600">Modal, Authentication, @tracked vs Lifecycle</p>
          </div>
          <div class="bg-white p-4 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900">16-18: Async & Testing</h3>
            <p class="text-sm text-gray-600">Cleanup, Test Waiters, ember-concurrency</p>
          </div>
        </div>
      </section>

      {{! Component Demos }}
      <section class="mb-12">
        <h2 class="text-2xl font-semibold text-gray-800 mb-6 border-b pb-2">
          Component Demos
        </h2>

        {{! Counter Demo }}
        <div class="bg-white p-6 rounded-lg shadow-sm border mb-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">Counter (Exercise 01)</h3>
          <p class="text-sm text-gray-600 mb-4">Basic @tracked state and actions</p>
          <Counter />
        </div>

        {{! Alert Demo }}
        <div class="bg-white p-6 rounded-lg shadow-sm border mb-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">Alert (Exercise 15)</h3>
          <p class="text-sm text-gray-600 mb-4">Demonstrates @tracked for declarative styling with Tailwind CSS</p>
          <div class="flex gap-2 mb-4">
            <button
              type="button"
              class="px-3 py-1 text-sm rounded bg-blue-100 text-blue-800 hover:bg-blue-200"
              {{on "click" (fn this.setAlertVariant "info")}}
            >Info</button>
            <button
              type="button"
              class="px-3 py-1 text-sm rounded bg-green-100 text-green-800 hover:bg-green-200"
              {{on "click" (fn this.setAlertVariant "success")}}
            >Success</button>
            <button
              type="button"
              class="px-3 py-1 text-sm rounded bg-yellow-100 text-yellow-800 hover:bg-yellow-200"
              {{on "click" (fn this.setAlertVariant "warning")}}
            >Warning</button>
            <button
              type="button"
              class="px-3 py-1 text-sm rounded bg-red-100 text-red-800 hover:bg-red-200"
              {{on "click" (fn this.setAlertVariant "error")}}
            >Error</button>
          </div>
          <Alert @variant={{this.alertVariant}}>
            <strong>Alert Demo:</strong> This alert changes variant based on tracked state. Click the buttons above to see different styles.
          </Alert>
        </div>

        {{! AsyncButton Demo }}
        <div class="bg-white p-6 rounded-lg shadow-sm border mb-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">AsyncButton (Exercise 17)</h3>
          <p class="text-sm text-gray-600 mb-4">Uses waitForPromise from @ember/test-waiters for testable async operations</p>
          <div class="flex gap-4">
            <AsyncButton
              @onClick={{this.simulateAsync}}
              @label="Save Changes"
              @loadingLabel="Saving..."
              @successLabel="Saved!"
              @successDuration={{2000}}
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-blue-300"
            />
            <AsyncButton
              @onClick={{this.simulateError}}
              @label="Trigger Error"
              @loadingLabel="Working..."
              @errorLabel="Failed!"
              class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 disabled:bg-red-300"
            />
          </div>
        </div>

        {{! SearchBox Demo }}
        <div class="bg-white p-6 rounded-lg shadow-sm border mb-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">SearchBox (Exercise 18)</h3>
          <p class="text-sm text-gray-600 mb-4">
            Uses ember-concurrency with restartable tasks and lastSuccessful pattern.
            Each SearchBox has its own independent task instance.
          </p>
          <div class="grid md:grid-cols-2 gap-4">
            <div>
              <p class="text-xs text-gray-500 mb-2">Search Box 1 (Independent)</p>
              <SearchBox @placeholder="Search products..." @debounceMs={{300}} />
            </div>
            <div>
              <p class="text-xs text-gray-500 mb-2">Search Box 2 (Independent)</p>
              <SearchBox @placeholder="Search users..." @debounceMs={{300}} />
            </div>
          </div>
          <p class="text-xs text-gray-500 mt-4 italic">
            Try typing in both boxes - cancelling one does not affect the other (independent tasks)
          </p>
        </div>

        {{! GlobalSearchBox Demo }}
        <div class="bg-white p-6 rounded-lg shadow-sm border mb-6">
          <h3 class="text-lg font-medium text-gray-900 mb-4">GlobalSearchBox (Exercise 18)</h3>
          <p class="text-sm text-gray-600 mb-4">
            Shares a single task via a service - all instances share the same state.
            Cancelling from one box cancels for all.
          </p>
          <div class="grid md:grid-cols-2 gap-4">
            <div>
              <p class="text-xs text-gray-500 mb-2">Global Search 1 (Shared)</p>
              <GlobalSearchBox @placeholder="Global search..." />
            </div>
            <div>
              <p class="text-xs text-gray-500 mb-2">Global Search 2 (Shared)</p>
              <GlobalSearchBox @placeholder="Also global..." />
            </div>
          </div>
          <p class="text-xs text-gray-500 mt-4 italic">
            Both boxes share the same results, history, and task - search from either to see shared state
          </p>
        </div>
      </section>

      {{! Key Concepts }}
      <section class="mb-12">
        <h2 class="text-2xl font-semibold text-gray-800 mb-6 border-b pb-2">
          Key Concepts Covered
        </h2>
        <div class="grid md:grid-cols-2 gap-6">
          <div class="bg-white p-6 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900 mb-2">State Management</h3>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>@tracked for reactive state</li>
              <li>@cached for expensive computations</li>
              <li>Services for shared state</li>
            </ul>
          </div>
          <div class="bg-white p-6 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900 mb-2">Async Patterns</h3>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>ember-concurrency tasks</li>
              <li>lastSuccessful for stale-while-revalidate</li>
              <li>Test waiters for async testing</li>
            </ul>
          </div>
          <div class="bg-white p-6 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900 mb-2">Component Patterns</h3>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>Glimmer components with signatures</li>
              <li>Yields and blocks</li>
              <li>Modifiers for DOM interactions</li>
            </ul>
          </div>
          <div class="bg-white p-6 rounded-lg shadow-sm border">
            <h3 class="font-medium text-gray-900 mb-2">Cleanup & Lifecycle</h3>
            <ul class="text-sm text-gray-600 space-y-1">
              <li>registerDestructor for cleanup</li>
              <li>Modifier cleanup functions</li>
              <li>isDestroying checks for async</li>
            </ul>
          </div>
        </div>
      </section>

      {{! Footer }}
      <footer class="text-center text-gray-500 text-sm">
        <p>
          Built with Ember.js, TypeScript, Glint, Tailwind CSS, and ember-concurrency
        </p>
      </footer>
    </div>
  </template>
}

<template>
  <DemoPage />
</template>
