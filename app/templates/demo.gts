import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { fn, hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';

import { Alert } from 'ember-learning/components/alert';
import { AsyncButton } from 'ember-learning/components/async-button';
import { SearchBox } from 'ember-learning/components/search-box';
import { GlobalSearchBox } from 'ember-learning/components/global-search-box';
import { Counter } from 'ember-learning/components/counter';
import { ProfileEditor } from 'ember-learning/components/profile-editor';
import { Modal } from 'ember-learning/components/modal';
import { LoginForm } from 'ember-learning/components/login-form';
import { RegistrationForm } from 'ember-learning/components/registration-form';
import { UserList } from 'ember-learning/components/user-list';
import { UserCard } from 'ember-learning/components/user-card';
import { ProductCard } from 'ember-learning/components/product-card';

import { Button } from 'ember-learning/components/ui/button';
import { Badge } from 'ember-learning/components/ui/badge';
import { ThemeSwitcher } from 'ember-learning/components/theme-switcher';
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
  CardContent,
  CardFooter,
} from 'ember-learning/components/ui/card';
import { Tabs } from 'ember-learning/components/ui/tabs';
import { Separator } from 'ember-learning/components/ui/separator';
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
  TableCaption,
} from 'ember-learning/components/ui/table';
import { eq } from 'ember-learning/helpers/eq';

type AlertVariant = 'info' | 'success' | 'warning' | 'error';

// Sample data for demos
const sampleUser = {
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
  isOnline: true,
  isPremium: true,
};

const sampleProducts = [
  { id: '1', name: 'Wireless Headphones', price: 99.99 },
  { id: '2', name: 'Mechanical Keyboard', price: 149.99 },
  { id: '3', name: 'USB-C Hub', price: 49.99 },
];

class DemoPage extends Component {
  @tracked alertVariant: AlertVariant = 'info';
  @tracked formMessage: string | null = null;

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

  @action
  handleLoginSuccess(): void {
    this.formMessage = 'Login successful!';
    setTimeout(() => (this.formMessage = null), 3000);
  }

  @action
  handleRegistration(data: {
    username: string;
    email: string;
  }): void {
    this.formMessage = `Registered: ${data.username} (${data.email})`;
    setTimeout(() => (this.formMessage = null), 3000);
  }

  @action
  handleContactUser(user: { firstName: string; lastName: string }): void {
    this.formMessage = `Contacting ${user.firstName} ${user.lastName}...`;
    setTimeout(() => (this.formMessage = null), 3000);
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
            Interactive demos of all components built throughout the exercises.
            Click on each tab to explore different patterns.
          </p>
        </div>

        {{! Form Message Toast }}
        {{#if this.formMessage}}
          <div
            class="fixed top-20 right-4 z-50 animate-in slide-in-from-right"
          >
            <Alert @variant="success" @dismissible={{true}}>
              {{this.formMessage}}
            </Alert>
          </div>
        {{/if}}

        {{! Tabs for Demo Content }}
        <Tabs @defaultValue="ui-components" @class="w-full" as |t|>
          <t.List @class="flex flex-wrap h-auto gap-1 mb-8 bg-transparent p-0">
            <t.Trigger
              @value="ui-components"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              UI Components
              <Badge @variant="secondary" @class="ml-1.5 text-xs">Base</Badge>
            </t.Trigger>
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
              @value="modal"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Modal
              <Badge @variant="secondary" @class="ml-1.5 text-xs">#16</Badge>
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
            <t.Trigger
              @value="forms"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Forms
              <Badge @variant="secondary" @class="ml-1.5 text-xs">Auth</Badge>
            </t.Trigger>
            <t.Trigger
              @value="users"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Users
              <Badge @variant="secondary" @class="ml-1.5 text-xs">Data</Badge>
            </t.Trigger>
            <t.Trigger
              @value="products"
              @class="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground rounded-full px-4"
            >
              Products
              <Badge @variant="secondary" @class="ml-1.5 text-xs">E-comm</Badge>
            </t.Trigger>
          </t.List>

          {{! UI Components Section }}
          <t.Content @value="ui-components">
            <div class="space-y-6">
              {{! Button Variants }}
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-slate-500/10 to-gray-600/10 border-b"
                >
                  <CardTitle>Button Component</CardTitle>
                  <CardDescription>Multiple variants and sizes for different
                    contexts</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6 space-y-6">
                  <div>
                    <p
                      class="text-sm font-medium text-muted-foreground mb-3"
                    >Variants</p>
                    <div class="flex flex-wrap gap-3">
                      <Button @variant="default">Default</Button>
                      <Button @variant="secondary">Secondary</Button>
                      <Button @variant="destructive">Destructive</Button>
                      <Button @variant="outline">Outline</Button>
                      <Button @variant="ghost">Ghost</Button>
                      <Button @variant="link">Link</Button>
                    </div>
                  </div>
                  <Separator />
                  <div>
                    <p
                      class="text-sm font-medium text-muted-foreground mb-3"
                    >Sizes</p>
                    <div class="flex flex-wrap gap-3 items-center">
                      <Button @size="sm">Small</Button>
                      <Button @size="default">Default</Button>
                      <Button @size="lg">Large</Button>
                      <Button @size="icon" aria-label="Settings">
                        <svg
                          class="w-4 h-4"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
                          />
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                          />
                        </svg>
                      </Button>
                    </div>
                  </div>
                  <Separator />
                  <div>
                    <p
                      class="text-sm font-medium text-muted-foreground mb-3"
                    >States</p>
                    <div class="flex flex-wrap gap-3">
                      <Button @disabled={{true}}>Disabled</Button>
                      <Button @variant="outline" @disabled={{true}}>Disabled
                        Outline</Button>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {{! Badge Variants }}
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-indigo-500/10 to-blue-600/10 border-b"
                >
                  <CardTitle>Badge Component</CardTitle>
                  <CardDescription>Status indicators and labels</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <div class="flex flex-wrap gap-3">
                    <Badge @variant="default">Default</Badge>
                    <Badge @variant="secondary">Secondary</Badge>
                    <Badge @variant="destructive">Destructive</Badge>
                    <Badge @variant="outline">Outline</Badge>
                  </div>
                </CardContent>
              </Card>

              {{! Table }}
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-green-500/10 to-emerald-600/10 border-b"
                >
                  <CardTitle>Table Component</CardTitle>
                  <CardDescription>Semantic HTML tables with styling</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <Table>
                    <TableCaption>A list of recent invoices</TableCaption>
                    <TableHeader>
                      <TableRow>
                        <TableHead>Invoice</TableHead>
                        <TableHead>Status</TableHead>
                        <TableHead>Method</TableHead>
                        <TableHead @class="text-right">Amount</TableHead>
                      </TableRow>
                    </TableHeader>
                    <TableBody>
                      <TableRow>
                        <TableCell @class="font-medium">INV001</TableCell>
                        <TableCell><Badge
                            @variant="default"
                          >Paid</Badge></TableCell>
                        <TableCell>Credit Card</TableCell>
                        <TableCell @class="text-right">$250.00</TableCell>
                      </TableRow>
                      <TableRow>
                        <TableCell @class="font-medium">INV002</TableCell>
                        <TableCell><Badge
                            @variant="secondary"
                          >Pending</Badge></TableCell>
                        <TableCell>PayPal</TableCell>
                        <TableCell @class="text-right">$150.00</TableCell>
                      </TableRow>
                      <TableRow>
                        <TableCell @class="font-medium">INV003</TableCell>
                        <TableCell><Badge
                            @variant="destructive"
                          >Unpaid</Badge></TableCell>
                        <TableCell>Bank Transfer</TableCell>
                        <TableCell @class="text-right">$350.00</TableCell>
                      </TableRow>
                    </TableBody>
                  </Table>
                </CardContent>
              </Card>

              {{! Card }}
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-purple-500/10 to-violet-600/10 border-b"
                >
                  <CardTitle>Card Component</CardTitle>
                  <CardDescription>Flexible container with header, content, and
                    footer</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <div class="grid md:grid-cols-2 gap-4">
                    <Card>
                      <CardHeader>
                        <CardTitle>Simple Card</CardTitle>
                        <CardDescription>A basic card example</CardDescription>
                      </CardHeader>
                      <CardContent>
                        <p class="text-muted-foreground">
                          Cards are used to group related content and actions.
                        </p>
                      </CardContent>
                    </Card>
                    <Card>
                      <CardHeader>
                        <CardTitle>Card with Footer</CardTitle>
                        <CardDescription>Includes action buttons</CardDescription>
                      </CardHeader>
                      <CardContent>
                        <p class="text-muted-foreground">
                          Use the footer for primary actions.
                        </p>
                      </CardContent>
                      <CardFooter @class="border-t pt-6">
                        <Button @variant="outline" @size="sm">Cancel</Button>
                        <Button @size="sm" @class="ml-2">Save</Button>
                      </CardFooter>
                    </Card>
                  </div>
                </CardContent>
              </Card>
            </div>
          </t.Content>

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

          {{! Modal Section }}
          <t.Content @value="modal">
            <Card>
              <CardHeader
                @class="bg-gradient-to-r from-fuchsia-500/10 to-pink-600/10 border-b"
              >
                <CardTitle>Modal Component</CardTitle>
                <CardDescription>Exercise 16 - Compound components with focus
                  management</CardDescription>
              </CardHeader>
              <CardContent @class="pt-6">
                <p class="text-muted-foreground mb-6">
                  A fully accessible modal with
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >role="dialog"</code>,
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >aria-modal</code>, focus trapping, and Escape key handling.
                </p>
                <div class="flex flex-wrap gap-4">
                  <Modal @size="sm" as |m|>
                    <m.Trigger
                      class="px-4 py-2 bg-primary text-primary-foreground rounded-md hover:bg-primary/90"
                    >
                      Open Small Modal
                    </m.Trigger>
                    {{#if m.isOpen}}
                      <m.Header @title="Small Modal" />
                      <m.Body>
                        <p class="text-muted-foreground">
                          This is a small modal dialog. Press Escape or click
                          outside to close.
                        </p>
                      </m.Body>
                      <m.Footer>
                        <Button
                          @variant="outline"
                          {{on "click" m.close}}
                        >Cancel</Button>
                        <Button @class="ml-2" {{on "click" m.close}}>Confirm</Button>
                      </m.Footer>
                    {{/if}}
                  </Modal>

                  <Modal @size="md" as |m|>
                    <m.Trigger
                      class="px-4 py-2 bg-secondary text-secondary-foreground rounded-md hover:bg-secondary/90"
                    >
                      Open Medium Modal
                    </m.Trigger>
                    {{#if m.isOpen}}
                      <m.Header @title="Medium Modal" />
                      <m.Body>
                        <p class="text-muted-foreground mb-4">
                          This modal demonstrates the compound component pattern
                          with nested components for Header, Body, and Footer.
                        </p>
                        <div class="p-4 bg-muted rounded-lg">
                          <p class="text-sm font-medium">Features:</p>
                          <ul class="text-sm text-muted-foreground mt-2 space-y-1">
                            <li>Focus management on open</li>
                            <li>Focus restoration on close</li>
                            <li>Escape key handling</li>
                            <li>Backdrop click to close</li>
                          </ul>
                        </div>
                      </m.Body>
                      <m.Footer>
                        <Button @variant="ghost" {{on "click" m.close}}>Close</Button>
                      </m.Footer>
                    {{/if}}
                  </Modal>

                  <Modal @size="lg" @closeOnBackdropClick={{false}} as |m|>
                    <m.Trigger
                      class="px-4 py-2 bg-destructive text-white rounded-md hover:bg-destructive/90"
                    >
                      Modal (No Backdrop Close)
                    </m.Trigger>
                    {{#if m.isOpen}}
                      <m.Header @title="Protected Modal" />
                      <m.Body>
                        <p class="text-muted-foreground">
                          This modal has backdrop click disabled. You must use
                          the close button or press Escape to close it.
                        </p>
                      </m.Body>
                      <m.Footer>
                        <Button {{on "click" m.close}}>Got it</Button>
                      </m.Footer>
                    {{/if}}
                  </Modal>
                </div>
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

          {{! Forms Section }}
          <t.Content @value="forms">
            <div class="space-y-6">
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-sky-500/10 to-cyan-600/10 border-b"
                >
                  <CardTitle>Login Form</CardTitle>
                  <CardDescription>Authentication form with validation and async
                    submission</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Demonstrates form handling with
                    <code
                      class="bg-muted px-1.5 py-0.5 rounded text-sm"
                    >@tracked</code>
                    state, input binding, and async submission with error
                    handling.
                  </p>
                  <div
                    class="max-w-md mx-auto p-6 border rounded-lg bg-card space-y-4"
                  >
                    <LoginForm @onSuccess={{this.handleLoginSuccess}} />
                    <p class="text-xs text-muted-foreground">
                      Demo credentials: any email + password with 3+ characters
                    </p>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-lime-500/10 to-green-600/10 border-b"
                >
                  <CardTitle>Registration Form</CardTitle>
                  <CardDescription>Multi-field validation with password strength
                    indicator</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Complex form with field-level validation, touched state
                    tracking, and derived password strength.
                  </p>
                  <div
                    class="max-w-md mx-auto p-6 border rounded-lg bg-card space-y-4"
                  >
                    <RegistrationForm @onSubmit={{this.handleRegistration}} />
                  </div>
                </CardContent>
              </Card>
            </div>
          </t.Content>

          {{! Users Section }}
          <t.Content @value="users">
            <div class="space-y-6">
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-teal-500/10 to-emerald-600/10 border-b"
                >
                  <CardTitle>User List Component</CardTitle>
                  <CardDescription>Async data loading with loading, error, and
                    success states</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Uses
                    <code
                      class="bg-muted px-1.5 py-0.5 rounded text-sm"
                    >AsyncResource</code>
                    utility for data fetching with automatic state management.
                  </p>
                  <div class="border rounded-lg p-4 bg-muted/30">
                    <UserList />
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-blue-500/10 to-indigo-600/10 border-b"
                >
                  <CardTitle>User Card Component</CardTitle>
                  <CardDescription>Individual user display with derived state</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Displays user information with derived properties like
                    <code class="bg-muted px-1.5 py-0.5 rounded text-sm">fullName</code>
                    and
                    <code
                      class="bg-muted px-1.5 py-0.5 rounded text-sm"
                    >initials</code>.
                  </p>
                  <div class="grid md:grid-cols-2 gap-4">
                    <div class="border rounded-lg p-4 bg-card">
                      <UserCard
                        @user={{sampleUser}}
                        @onContact={{this.handleContactUser}}
                      />
                    </div>
                    <div class="border rounded-lg p-4 bg-card">
                      <UserCard
                        @user={{hash
                          firstName="Jane"
                          lastName="Smith"
                          email="jane@example.com"
                          isOnline=false
                          isPremium=false
                        }}
                        @onContact={{this.handleContactUser}}
                      />
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </t.Content>

          {{! Products Section }}
          <t.Content @value="products">
            <Card>
              <CardHeader
                @class="bg-gradient-to-r from-orange-500/10 to-red-600/10 border-b"
              >
                <CardTitle>Product Card Component</CardTitle>
                <CardDescription>E-commerce product display with shopping cart
                  integration</CardDescription>
              </CardHeader>
              <CardContent @class="pt-6">
                <p class="text-muted-foreground mb-6">
                  Product cards with service injection for shopping cart
                  functionality. Uses
                  <code
                    class="bg-muted px-1.5 py-0.5 rounded text-sm"
                  >@service</code>
                  decorator for cart integration.
                </p>
                <div class="grid md:grid-cols-3 gap-6">
                  {{#each sampleProducts as |product|}}
                    <div
                      class="border rounded-lg p-4 bg-card hover:shadow-lg transition-shadow"
                    >
                      <ProductCard @product={{product}} />
                    </div>
                  {{/each}}
                </div>
                <p class="mt-4 text-sm text-muted-foreground italic">
                  Click "Add to Cart" to add items. Check the shopping cart
                  service to see items accumulate.
                </p>
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
