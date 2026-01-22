import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';

import { Alert } from 'ember-learning/components/alert';
import { AsyncButton } from 'ember-learning/components/async-button';
import { SearchBox } from 'ember-learning/components/search-box';
import { GlobalSearchBox } from 'ember-learning/components/global-search-box';
import { Counter } from 'ember-learning/components/counter';
import { ProfileEditor } from 'ember-learning/components/profile-editor';

import { Button } from 'ember-learning/components/ui/button';
import { Badge } from 'ember-learning/components/ui/badge';
import { ThemeSwitcher } from 'ember-learning/components/theme-switcher';
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
} from 'ember-learning/components/ui/card';
import { Tabs } from 'ember-learning/components/ui/tabs';
import { Separator } from 'ember-learning/components/ui/separator';
import { eq } from 'ember-learning/helpers/eq';

type AlertVariant = 'info' | 'success' | 'warning' | 'error';

class DemoPage extends Component {
  @tracked alertVariant: AlertVariant = 'info';

  @action
  setAlertVariant(variant: AlertVariant): void {
    this.alertVariant = variant;
  }

  @action
  async simulateAsync(): Promise<void> {
    await new Promise((resolve) => setTimeout(resolve, 1500));
  }

  @action
  async simulateError(): Promise<void> {
    await Promise.resolve();
    throw new Error('Simulated error');
  }

  <template>
    <div class="min-h-screen bg-background">
      {{! Navigation }}
      <nav class="bg-card border-b sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex justify-between h-16">
            <div class="flex items-center">
              <Button
                @asChild={{true}}
                @variant="ghost"
                @class="p-0 hover:bg-transparent"
              >
                <:default as |b|>
                  <LinkTo
                    @route="index"
                    class="{{b.classes}} flex items-center space-x-3 group"
                  >
                    <div
                      class="w-10 h-10 bg-gradient-to-br from-orange-500 to-red-600 rounded-xl flex items-center justify-center shadow-lg group-hover:shadow-xl transition-shadow"
                    >
                      <span class="text-white font-bold text-lg">E</span>
                    </div>
                    <span class="text-xl font-bold text-foreground">Ember
                      Learning</span>
                  </LinkTo>
                </:default>
              </Button>
            </div>
            <div class="flex items-center space-x-2">
              <Button @asChild={{true}} @variant="ghost">
                <:default as |b|>
                  <LinkTo @route="index" class={{b.classes}}>
                    Home
                  </LinkTo>
                </:default>
              </Button>
              <Button @variant="ghost" @class="text-primary">
                Demo
              </Button>
              <ThemeSwitcher />
            </div>
          </div>
        </div>
      </nav>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {{! Header }}
        <div class="text-center mb-12">
          <h1 class="text-4xl font-bold text-foreground mb-4">
            Component Playground
          </h1>
          <p class="text-lg text-muted-foreground max-w-2xl mx-auto">
            Interactive demos of the components built throughout the exercises.
            Click on each tab to explore different patterns.
          </p>
        </div>

        {{! Tabs for Demo Content }}
        <Tabs @defaultValue="counter" @class="w-full" as |t|>
          <t.List @class="flex flex-wrap h-auto gap-1 mb-8 bg-transparent p-0">
            <t.Trigger
              @value="counter"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Counter
              <Badge @variant="secondary" @class="ml-1.5 text-xs">#02</Badge>
            </t.Trigger>
            <t.Trigger
              @value="alert"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Alert
              <Badge @variant="secondary" @class="ml-1.5 text-xs">#15</Badge>
            </t.Trigger>
            <t.Trigger
              @value="async-button"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Async Button
              <Badge @variant="secondary" @class="ml-1.5 text-xs">#17</Badge>
            </t.Trigger>
            <t.Trigger
              @value="search"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Search Box
              <Badge @variant="secondary" @class="ml-1.5 text-xs">#18</Badge>
            </t.Trigger>
            <t.Trigger
              @value="global-search"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Global Search
              <Badge @variant="secondary" @class="ml-1.5 text-xs">#18</Badge>
            </t.Trigger>
            <t.Trigger
              @value="profile"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Profile Editor
              <Badge @variant="secondary" @class="ml-1.5 text-xs">#19</Badge>
            </t.Trigger>
          </t.List>

          {{! Counter Section }}
          <t.Content @value="counter">
            <Card>
              <CardHeader
                @class="bg-gradient-to-r from-blue-500/10 to-indigo-600/10 border-b"
              >
                <CardTitle>Counter Component</CardTitle>
                <CardDescription>Exercise 02 - @tracked state and actions</CardDescription>
              </CardHeader>
              <CardContent @class="pt-6">
                <p class="text-muted-foreground mb-6">
                  Demonstrates basic reactive state with
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >@tracked</code>
                  and event handling with
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >@action</code>.
                </p>
                <div class="flex flex-wrap gap-6 items-start">
                  <div class="flex-1 min-w-[200px]">
                    <p
                      class="text-sm font-medium text-muted-foreground mb-2"
                    >Default (starts at 0)</p>
                    <Counter />
                  </div>
                  <div class="flex-1 min-w-[200px]">
                    <p
                      class="text-sm font-medium text-muted-foreground mb-2"
                    >Custom initial value (10)</p>
                    <Counter @initialValue={{10}} />
                  </div>
                </div>
              </CardContent>
            </Card>
          </t.Content>

          {{! Alert Section }}
          <t.Content @value="alert">
            <Card>
              <CardHeader
                @class="bg-gradient-to-r from-emerald-500/10 to-teal-600/10 border-b"
              >
                <CardTitle>Alert Component</CardTitle>
                <CardDescription>Exercise 15 - Declarative styling with @tracked</CardDescription>
              </CardHeader>
              <CardContent @class="pt-6">
                <p class="text-muted-foreground mb-6">
                  Shows how
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >@tracked</code>
                  properties can drive Tailwind CSS classes declaratively,
                  avoiding lifecycle modifiers.
                </p>
                <div class="flex flex-wrap gap-2 mb-6">
                  <Button
                    @variant={{if
                      (eq this.alertVariant "info")
                      "default"
                      "outline"
                    }}
                    @size="sm"
                    @class="capitalize"
                    {{on "click" (fn this.setAlertVariant "info")}}
                  >
                    info
                  </Button>
                  <Button
                    @variant={{if
                      (eq this.alertVariant "success")
                      "default"
                      "outline"
                    }}
                    @size="sm"
                    @class="capitalize"
                    {{on "click" (fn this.setAlertVariant "success")}}
                  >
                    success
                  </Button>
                  <Button
                    @variant={{if
                      (eq this.alertVariant "warning")
                      "default"
                      "outline"
                    }}
                    @size="sm"
                    @class="capitalize"
                    {{on "click" (fn this.setAlertVariant "warning")}}
                  >
                    warning
                  </Button>
                  <Button
                    @variant={{if
                      (eq this.alertVariant "error")
                      "default"
                      "outline"
                    }}
                    @size="sm"
                    @class="capitalize"
                    {{on "click" (fn this.setAlertVariant "error")}}
                  >
                    error
                  </Button>
                </div>
                <Alert @variant={{this.alertVariant}} @dismissible={{true}}>
                  <strong class="font-semibold">{{this.alertVariant}}
                    alert:</strong>
                  This alert changes variant based on tracked state. The styling
                  is entirely declarative.
                </Alert>
              </CardContent>
            </Card>
          </t.Content>

          {{! AsyncButton Section }}
          <t.Content @value="async-button">
            <Card>
              <CardHeader
                @class="bg-gradient-to-r from-violet-500/10 to-purple-600/10 border-b"
              >
                <CardTitle>Async Button Component</CardTitle>
                <CardDescription>Exercise 17 - Test waiters for async operations</CardDescription>
              </CardHeader>
              <CardContent @class="pt-6">
                <p class="text-muted-foreground mb-6">
                  Uses
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >waitForPromise</code>
                  from
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >@ember/test-waiters</code>
                  to ensure tests properly wait for async operations.
                </p>
                <div class="flex flex-wrap gap-4">
                  <AsyncButton
                    @onClick={{this.simulateAsync}}
                    @label="Save Changes"
                    @loadingLabel="Saving..."
                    @successLabel="Saved!"
                    @successDuration={{2000}}
                    class="px-6 py-3 bg-gradient-to-r from-violet-500 to-purple-600 text-white rounded-xl font-medium hover:from-violet-600 hover:to-purple-700 disabled:from-slate-300 disabled:to-slate-400 shadow-lg shadow-violet-500/30 disabled:shadow-none transition-all"
                  />
                  <AsyncButton
                    @onClick={{this.simulateError}}
                    @label="Trigger Error"
                    @loadingLabel="Working..."
                    @errorLabel="Failed!"
                    class="px-6 py-3 bg-gradient-to-r from-red-500 to-rose-600 text-white rounded-xl font-medium hover:from-red-600 hover:to-rose-700 disabled:from-slate-300 disabled:to-slate-400 shadow-lg shadow-red-500/30 disabled:shadow-none transition-all"
                  />
                </div>
              </CardContent>
            </Card>
          </t.Content>

          {{! SearchBox Section }}
          <t.Content @value="search">
            <Card>
              <CardHeader
                @class="bg-gradient-to-r from-amber-500/10 to-orange-600/10 border-b"
              >
                <CardTitle>Search Box Component</CardTitle>
                <CardDescription>Exercise 18 - ember-concurrency with
                  independent tasks</CardDescription>
              </CardHeader>
              <CardContent @class="pt-6">
                <p class="text-muted-foreground mb-6">
                  Each SearchBox has its
                  <strong>own independent task instance</strong>. Cancelling one
                  does not affect the other. Uses
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >restartable</code>
                  modifier and
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >lastSuccessful</code>
                  pattern.
                </p>
                <div class="grid md:grid-cols-2 gap-6">
                  <div class="space-y-2">
                    <label
                      class="block text-sm font-medium text-foreground"
                    >Search Box A</label>
                    <SearchBox
                      @placeholder="Search products..."
                      @debounceMs={{300}}
                    />
                  </div>
                  <div class="space-y-2">
                    <label
                      class="block text-sm font-medium text-foreground"
                    >Search Box B</label>
                    <SearchBox
                      @placeholder="Search users..."
                      @debounceMs={{300}}
                    />
                  </div>
                </div>
                <p class="mt-4 text-sm text-muted-foreground italic">
                  Try typing in both boxes and cancelling one - the other
                  continues unaffected.
                </p>
              </CardContent>
            </Card>
          </t.Content>

          {{! GlobalSearchBox Section }}
          <t.Content @value="global-search">
            <Card>
              <CardHeader
                @class="bg-gradient-to-r from-cyan-500/10 to-blue-600/10 border-b"
              >
                <CardTitle>Global Search Box Component</CardTitle>
                <CardDescription>Exercise 18 - Shared tasks via service</CardDescription>
              </CardHeader>
              <CardContent @class="pt-6">
                <p class="text-muted-foreground mb-6">
                  Both boxes share the
                  <strong>same task via a service</strong>. Searching from one
                  updates both. Cancelling from either box cancels for all.
                </p>
                <div class="grid md:grid-cols-2 gap-6">
                  <div class="space-y-2">
                    <label
                      class="block text-sm font-medium text-foreground"
                    >Global Search A</label>
                    <GlobalSearchBox @placeholder="Global search..." />
                  </div>
                  <div class="space-y-2">
                    <label
                      class="block text-sm font-medium text-foreground"
                    >Global Search B</label>
                    <GlobalSearchBox @placeholder="Also global..." />
                  </div>
                </div>
                <p class="mt-4 text-sm text-muted-foreground italic">
                  Notice both share the same results and history - they use a
                  shared service task.
                </p>
              </CardContent>
            </Card>
          </t.Content>

          {{! ProfileEditor Section }}
          <t.Content @value="profile">
            <Card>
              <CardHeader
                @class="bg-gradient-to-r from-rose-500/10 to-pink-600/10 border-b"
              >
                <CardTitle>Profile Editor Component</CardTitle>
                <CardDescription>Exercise 19 - Granular reactivity comparison</CardDescription>
              </CardHeader>
              <CardContent @class="pt-6">
                <p class="text-muted-foreground mb-6">
                  Compares
                  <strong>single object state</strong>
                  (anti-pattern) vs
                  <strong>granular @tracked properties</strong>
                  (recommended). Watch the render counts to understand the
                  difference.
                </p>
                <div class="grid lg:grid-cols-2 gap-6">
                  <ProfileEditor @mode="object" />
                  <ProfileEditor @mode="granular" />
                </div>
              </CardContent>
            </Card>
          </t.Content>
        </Tabs>

        {{! Footer }}
        <footer class="mt-16">
          <Separator @class="mb-6" />
          <p class="text-center text-muted-foreground text-sm">
            Built with Ember.js, TypeScript, Glint, Tailwind CSS, and
            ember-concurrency
          </p>
        </footer>
      </div>
    </div>
  </template>
}

<template><DemoPage /></template>
