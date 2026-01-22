import { LinkTo } from '@ember/routing';
import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import type ShoppingCartService from 'ember-learning/services/shopping-cart';
import { Button } from 'ember-learning/components/ui/button';
import { Card, CardContent } from 'ember-learning/components/ui/card';
import { Badge } from 'ember-learning/components/ui/badge';

interface Product {
  id: string;
  name: string;
  price: number;
  image?: string;
  description?: string;
}

interface Signature {
  Args: {
    model: Product | null;
  };
  Element: HTMLDivElement;
}

// Generate a gradient based on product id for placeholder
function getPlaceholderGradient(id: string): string {
  const gradients = [
    'from-violet-500 to-purple-600',
    'from-cyan-500 to-blue-600',
    'from-emerald-500 to-teal-600',
    'from-orange-500 to-red-600',
    'from-pink-500 to-rose-600',
    'from-indigo-500 to-blue-600',
  ];
  const index = parseInt(id, 10) % gradients.length;
  return gradients[index] ?? gradients[0]!;
}

class ProductTemplate extends Component<Signature> {
  @service declare shoppingCart: ShoppingCartService;

  get formattedPrice(): string {
    return this.args.model ? `$${this.args.model.price.toFixed(2)}` : '';
  }

  get placeholderGradient(): string {
    return this.args.model
      ? getPlaceholderGradient(this.args.model.id)
      : 'from-gray-400 to-gray-500';
  }

  @action
  addToCart(): void {
    if (this.args.model) {
      this.shoppingCart.addItem({
        id: this.args.model.id,
        name: this.args.model.name,
        price: this.args.model.price,
      });
    }
  }

  <template>
    <div
      class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
    >
      <Card class="w-full max-w-4xl max-h-[90vh] overflow-auto">
        {{#if @model}}
          <div data-test-product-detail>
            {{! Back Navigation }}
            <div class="p-4 border-b flex items-center gap-4">
              <Button @asChild={{true}} @variant="ghost" @size="sm">
                <:default as |b|>
                  <LinkTo
                    @route="products"
                    data-test-back-link
                    class="{{b.classes}} flex items-center gap-2"
                  >
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
                        d="M15 19l-7-7 7-7"
                      />
                    </svg>
                    Back to Products
                  </LinkTo>
                </:default>
              </Button>
              <span class="text-muted-foreground">|</span>
              <Button @asChild={{true}} @variant="ghost" @size="sm">
                <:default as |b|>
                  <LinkTo
                    @route="demo"
                    class="{{b.classes}} flex items-center gap-2"
                  >
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
                        d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"
                      />
                    </svg>
                    Go to Demo
                  </LinkTo>
                </:default>
              </Button>
            </div>

            <CardContent @class="p-0">
              <div class="grid md:grid-cols-2 gap-0">
                {{! Product Image }}
                <div class="aspect-square md:aspect-auto md:h-full">
                  {{#if @model.image}}
                    <img
                      src={{@model.image}}
                      alt={{@model.name}}
                      class="w-full h-full object-cover"
                    />
                  {{else}}
                    <div
                      class="w-full h-full min-h-[300px] bg-gradient-to-br
                        {{this.placeholderGradient}}
                        flex items-center justify-center"
                    >
                      <svg
                        class="w-24 h-24 text-white/80"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="1.5"
                          d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"
                        />
                      </svg>
                    </div>
                  {{/if}}
                </div>

                {{! Product Details }}
                <div class="p-6 flex flex-col">
                  <div class="flex-1">
                    <div class="flex items-start justify-between gap-4">
                      <h1
                        data-test-product-name
                        class="text-2xl font-bold text-foreground"
                      >
                        {{@model.name}}
                      </h1>
                      <Badge @variant="secondary">In Stock</Badge>
                    </div>

                    <p
                      class="mt-4 text-3xl font-bold text-primary"
                    >{{this.formattedPrice}}</p>

                    <div class="mt-6">
                      <h3
                        class="text-sm font-medium text-muted-foreground uppercase tracking-wide"
                      >Description</h3>
                      <p class="mt-2 text-foreground leading-relaxed">
                        {{#if @model.description}}
                          {{@model.description}}
                        {{else}}
                          Experience premium quality with this exceptional
                          product. Crafted with attention to detail and designed
                          to exceed your expectations. Perfect for everyday use
                          and built to last.
                        {{/if}}
                      </p>
                    </div>

                    <div class="mt-6">
                      <h3
                        class="text-sm font-medium text-muted-foreground uppercase tracking-wide"
                      >Features</h3>
                      <ul class="mt-2 space-y-2">
                        <li class="flex items-center gap-2 text-foreground">
                          <svg
                            class="w-5 h-5 text-green-500"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M5 13l4 4L19 7"
                            />
                          </svg>
                          Premium quality materials
                        </li>
                        <li class="flex items-center gap-2 text-foreground">
                          <svg
                            class="w-5 h-5 text-green-500"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M5 13l4 4L19 7"
                            />
                          </svg>
                          30-day money-back guarantee
                        </li>
                        <li class="flex items-center gap-2 text-foreground">
                          <svg
                            class="w-5 h-5 text-green-500"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M5 13l4 4L19 7"
                            />
                          </svg>
                          Free shipping on orders over $50
                        </li>
                      </ul>
                    </div>
                  </div>

                  {{! Add to Cart }}
                  <div class="mt-8 pt-6 border-t">
                    <Button
                      @class="w-full py-6 text-lg"
                      {{on "click" this.addToCart}}
                    >
                      <svg
                        class="w-5 h-5 mr-2"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"
                        />
                      </svg>
                      Add to Cart
                    </Button>
                  </div>
                </div>
              </div>
            </CardContent>
          </div>
        {{else}}
          <div data-test-not-found class="p-8 text-center">
            <svg
              class="w-16 h-16 mx-auto text-muted-foreground/50"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="1.5"
                d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
            <h2 class="mt-4 text-xl font-semibold text-foreground">Product not
              found</h2>
            <p class="mt-2 text-muted-foreground">The product you're looking for
              doesn't exist or has been removed.</p>
            <div class="mt-6 flex justify-center gap-4">
              <Button @asChild={{true}} @variant="outline">
                <:default as |b|>
                  <LinkTo
                    @route="products"
                    data-test-back-link
                    class={{b.classes}}
                  >
                    Back to Products
                  </LinkTo>
                </:default>
              </Button>
              <Button @asChild={{true}}>
                <:default as |b|>
                  <LinkTo @route="demo" class={{b.classes}}>
                    Go to Demo
                  </LinkTo>
                </:default>
              </Button>
            </div>
          </div>
        {{/if}}
      </Card>
    </div>
  </template>
}

export default ProductTemplate;
