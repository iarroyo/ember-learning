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
type ComponentView =
  | 'ui-components'
  | 'counter'
  | 'alert'
  | 'modal'
  | 'async-button'
  | 'search'
  | 'global-search'
  | 'profile'
  | 'forms'
  | 'users'
  | 'products';

interface NavItem {
  id: ComponentView;
  label: string;
  badge: string;
  category: string;
}

const navItems: NavItem[] = [
  {
    id: 'ui-components',
    label: 'UI Components',
    badge: 'Base',
    category: 'Foundation',
  },
  { id: 'counter', label: 'Counter', badge: '#02', category: 'Foundation' },
  { id: 'alert', label: 'Alert', badge: '#15', category: 'Feedback' },
  { id: 'modal', label: 'Modal', badge: '#16', category: 'Feedback' },
  {
    id: 'async-button',
    label: 'Async Button',
    badge: '#17',
    category: 'Feedback',
  },
  { id: 'search', label: 'Search Box', badge: '#18', category: 'Data' },
  {
    id: 'global-search',
    label: 'Global Search',
    badge: '#18',
    category: 'Data',
  },
  { id: 'profile', label: 'Profile Editor', badge: '#19', category: 'Data' },
  { id: 'forms', label: 'Forms', badge: 'Auth', category: 'Authentication' },
  { id: 'users', label: 'Users', badge: 'Data', category: 'Data' },
  {
    id: 'products',
    label: 'Products',
    badge: 'E-comm',
    category: 'E-commerce',
  },
];

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
  @tracked currentView: ComponentView = 'ui-components';
  @tracked alertVariant: AlertVariant = 'info';
  @tracked formMessage: string | null = null;

  navItems = navItems;

  @action
  setView(view: ComponentView): void {
    this.currentView = view;
  }

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
  handleRegistration(data: { username: string; email: string }): void {
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
      <nav
        aria-label="Main navigation"
        class="bg-card border-b sticky top-0 z-50"
      >
        <div class="max-w-[1600px] mx-auto px-4 sm:px-6 lg:px-8">
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

      {{! Form Message Toast }}
      {{#if this.formMessage}}
        <div class="fixed top-20 right-4 z-50 animate-in slide-in-from-right">
          <Alert @variant="success" @dismissible={{true}}>
            {{this.formMessage}}
          </Alert>
        </div>
      {{/if}}

      <div class="flex">
        {{! Sidebar }}
        <aside
          class="w-64 border-r bg-card/50 min-h-[calc(100vh-4rem)] sticky top-16 overflow-y-auto"
        >
          <div class="p-4">
            <h2
              class="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-4"
            >
              Components
            </h2>
            <nav aria-label="Component navigation" class="space-y-1">
              {{#each this.navItems as |item|}}
                <button
                  type="button"
                  class="w-full flex items-center justify-between px-3 py-2 text-sm rounded-lg transition-colors
                    {{if
                      (eq this.currentView item.id)
                      'bg-primary text-primary-foreground'
                      'text-foreground hover:bg-muted'
                    }}"
                  {{on "click" (fn this.setView item.id)}}
                >
                  <span class="font-medium">{{item.label}}</span>
                  <Badge
                    @variant={{if
                      (eq this.currentView item.id)
                      "outline"
                      "secondary"
                    }}
                    @class="text-xs {{if
                      (eq this.currentView item.id)
                      'border-primary-foreground/30 text-primary-foreground'
                    }}"
                  >
                    {{item.badge}}
                  </Badge>
                </button>
              {{/each}}
            </nav>
          </div>
        </aside>

        {{! Main Content }}
        <main class="flex-1 p-8 max-w-5xl">
          {{! UI Components Section }}
          {{#if (eq this.currentView "ui-components")}}
            <div class="space-y-6">
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">UI Components</h1>
                <p class="text-muted-foreground mt-2">Base building blocks for
                  the application</p>
              </div>

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
          {{/if}}

          {{! Counter Section }}
          {{#if (eq this.currentView "counter")}}
            <div>
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Counter</h1>
                <p class="text-muted-foreground mt-2">Exercise 02 - @tracked
                  state and actions</p>
              </div>
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-blue-500/10 to-indigo-600/10 border-b"
                >
                  <CardTitle>Counter Component</CardTitle>
                  <CardDescription>Basic reactive state management</CardDescription>
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
            </div>
          {{/if}}

          {{! Alert Section }}
          {{#if (eq this.currentView "alert")}}
            <div>
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Alert</h1>
                <p class="text-muted-foreground mt-2">Exercise 15 - Declarative
                  styling with @tracked</p>
              </div>
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-emerald-500/10 to-teal-600/10 border-b"
                >
                  <CardTitle>Alert Component</CardTitle>
                  <CardDescription>Declarative variant switching</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Shows how
                    <code
                      class="bg-muted px-1.5 py-0.5 rounded text-sm"
                    >@tracked</code>
                    properties can drive Tailwind CSS classes declaratively.
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
                    This alert changes variant based on tracked state.
                  </Alert>
                </CardContent>
              </Card>
            </div>
          {{/if}}

          {{! Modal Section }}
          {{#if (eq this.currentView "modal")}}
            <div>
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Modal</h1>
                <p class="text-muted-foreground mt-2">Exercise 16 - Compound
                  components with focus management</p>
              </div>
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-fuchsia-500/10 to-pink-600/10 border-b"
                >
                  <CardTitle>Modal Component</CardTitle>
                  <CardDescription>Accessible dialog with focus management</CardDescription>
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
                          <Button
                            @class="ml-2"
                            {{on "click" m.close}}
                          >Confirm</Button>
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
                            This modal demonstrates the compound component
                            pattern with nested components.
                          </p>
                          <div class="p-4 bg-muted rounded-lg">
                            <p class="text-sm font-medium">Features:</p>
                            <ul
                              class="text-sm text-muted-foreground mt-2 space-y-1"
                            >
                              <li>Focus management on open</li>
                              <li>Focus restoration on close</li>
                              <li>Escape key handling</li>
                              <li>Backdrop click to close</li>
                            </ul>
                          </div>
                        </m.Body>
                        <m.Footer>
                          <Button
                            @variant="ghost"
                            {{on "click" m.close}}
                          >Close</Button>
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
                            the close button or press Escape.
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
            </div>
          {{/if}}

          {{! AsyncButton Section }}
          {{#if (eq this.currentView "async-button")}}
            <div>
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Async Button</h1>
                <p class="text-muted-foreground mt-2">Exercise 17 - Test waiters
                  for async operations</p>
              </div>
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-violet-500/10 to-purple-600/10 border-b"
                >
                  <CardTitle>Async Button Component</CardTitle>
                  <CardDescription>Button with loading, success, and error
                    states</CardDescription>
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
            </div>
          {{/if}}

          {{! SearchBox Section }}
          {{#if (eq this.currentView "search")}}
            <div>
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Search Box</h1>
                <p class="text-muted-foreground mt-2">Exercise 18 -
                  ember-concurrency with independent tasks</p>
              </div>
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-amber-500/10 to-orange-600/10 border-b"
                >
                  <CardTitle>Search Box Component</CardTitle>
                  <CardDescription>Independent task instances per component</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Each SearchBox has its
                    <strong>own independent task instance</strong>. Cancelling
                    one does not affect the other.
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
            </div>
          {{/if}}

          {{! GlobalSearchBox Section }}
          {{#if (eq this.currentView "global-search")}}
            <div>
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Global Search</h1>
                <p class="text-muted-foreground mt-2">Exercise 18 - Shared tasks
                  via service</p>
              </div>
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-cyan-500/10 to-blue-600/10 border-b"
                >
                  <CardTitle>Global Search Box Component</CardTitle>
                  <CardDescription>Shared task state across components</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Both boxes share the
                    <strong>same task via a service</strong>. Searching from one
                    updates both.
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
                    Notice both share the same results and history.
                  </p>
                </CardContent>
              </Card>
            </div>
          {{/if}}

          {{! ProfileEditor Section }}
          {{#if (eq this.currentView "profile")}}
            <div>
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Profile Editor</h1>
                <p class="text-muted-foreground mt-2">Exercise 19 - Granular
                  reactivity comparison</p>
              </div>
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-rose-500/10 to-pink-600/10 border-b"
                >
                  <CardTitle>Profile Editor Component</CardTitle>
                  <CardDescription>Object vs granular state comparison</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Compares
                    <strong>single object state</strong>
                    (anti-pattern) vs
                    <strong>granular @tracked properties</strong>
                    (recommended). Watch the render counts.
                  </p>
                  <div class="grid lg:grid-cols-2 gap-6">
                    <ProfileEditor @mode="object" />
                    <ProfileEditor @mode="granular" />
                  </div>
                </CardContent>
              </Card>
            </div>
          {{/if}}

          {{! Forms Section }}
          {{#if (eq this.currentView "forms")}}
            <div class="space-y-6">
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Forms</h1>
                <p class="text-muted-foreground mt-2">Authentication forms with
                  validation</p>
              </div>

              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-sky-500/10 to-cyan-600/10 border-b"
                >
                  <CardTitle>Login Form</CardTitle>
                  <CardDescription>Authentication form with async submission</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Demonstrates form handling with
                    <code
                      class="bg-muted px-1.5 py-0.5 rounded text-sm"
                    >@tracked</code>
                    state and async submission.
                  </p>
                  <div
                    class="max-w-md mx-auto p-6 border rounded-lg bg-card space-y-4"
                  >
                    <LoginForm @onSuccess={{this.handleLoginSuccess}} />
                    <p class="text-xs text-muted-foreground">
                      Demo: any email + password with 3+ characters
                    </p>
                  </div>
                </CardContent>
              </Card>

              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-lime-500/10 to-green-600/10 border-b"
                >
                  <CardTitle>Registration Form</CardTitle>
                  <CardDescription>Multi-field validation with password strength</CardDescription>
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
          {{/if}}

          {{! Users Section }}
          {{#if (eq this.currentView "users")}}
            <div class="space-y-6">
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Users</h1>
                <p class="text-muted-foreground mt-2">Async data loading and
                  display components</p>
              </div>

              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-teal-500/10 to-emerald-600/10 border-b"
                >
                  <CardTitle>User List Component</CardTitle>
                  <CardDescription>Async data loading with state management</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Uses
                    <code
                      class="bg-muted px-1.5 py-0.5 rounded text-sm"
                    >AsyncResource</code>
                    utility for data fetching with loading, error, and success
                    states.
                  </p>
                  <div class="border rounded-lg p-4 bg-muted/30">
                    <UserList @onContact={{this.handleContactUser}} />
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
                    <code
                      class="bg-muted px-1.5 py-0.5 rounded text-sm"
                    >fullName</code>
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
          {{/if}}

          {{! Products Section }}
          {{#if (eq this.currentView "products")}}
            <div>
              <div class="mb-8">
                <h1 class="text-3xl font-bold text-foreground">Products</h1>
                <p class="text-muted-foreground mt-2">E-commerce product display
                  with cart integration</p>
              </div>
              <Card>
                <CardHeader
                  @class="bg-gradient-to-r from-orange-500/10 to-red-600/10 border-b"
                >
                  <CardTitle>Product Card Component</CardTitle>
                  <CardDescription>Shopping cart integration via service</CardDescription>
                </CardHeader>
                <CardContent @class="pt-6">
                  <p class="text-muted-foreground mb-6">
                    Product cards with
                    <code
                      class="bg-muted px-1.5 py-0.5 rounded text-sm"
                    >@service</code>
                    decorator for shopping cart functionality.
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
                    Click "Add to Cart" to add items to the shopping cart
                    service.
                  </p>
                </CardContent>
              </Card>
            </div>
          {{/if}}

          {{! Footer }}
          <footer class="mt-16 pb-8">
            <Separator @class="mb-6" />
            <p class="text-center text-muted-foreground text-sm">
              Built with Ember.js, TypeScript, Glint, Tailwind CSS, and
              ember-concurrency
            </p>
          </footer>
        </main>
      </div>
    </div>
  </template>
}

<template><DemoPage /></template>
