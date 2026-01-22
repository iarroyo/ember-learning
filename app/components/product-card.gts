import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';
import { inject as service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import type ShoppingCartService from 'ember-learning/services/shopping-cart';

interface Product {
  id: string;
  name: string;
  price: number;
  image?: string;
}

interface ProductCardSignature {
  Args: {
    product: Product;
  };
  Element: HTMLDivElement;
}

export class ProductCard extends Component<ProductCardSignature> {
  @service declare shoppingCart: ShoppingCartService;

  get formattedPrice(): string {
    return `$${this.args.product.price.toFixed(2)}`;
  }


  @action
  addToCart(): void {
    this.shoppingCart.addItem({
      id: this.args.product.id,
      name: this.args.product.name,
      price: this.args.product.price,
    });
  }

  // Generate a gradient based on product id for placeholder
  get placeholderGradient(): string {
    const gradients = [
      'from-violet-500 to-purple-600',
      'from-cyan-500 to-blue-600',
      'from-emerald-500 to-teal-600',
      'from-orange-500 to-red-600',
      'from-pink-500 to-rose-600',
      'from-indigo-500 to-blue-600',
    ];
    const index = parseInt(this.args.product.id, 10) % gradients.length;
    return gradients[index] ?? gradients[0]!;
  }

  <template>
    <article
      aria-labelledby="product-{{@product.id}}-name"
      class="group flex flex-col h-full"
    >
      {{! Product Image / Placeholder }}
      <LinkTo
        @route="products.product"
        @model={{@product.id}}
        data-test-product-link
        class="block relative overflow-hidden rounded-t-lg aspect-square"
      >
        {{#if @product.image}}
          <img
            data-test-product-image
            src={{@product.image}}
            alt=""
            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
          />
        {{else}}
          <div
            class="w-full h-full bg-gradient-to-br
              {{this.placeholderGradient}}
              flex items-center justify-center group-hover:scale-105 transition-transform duration-300"
          >
            <svg
              class="w-16 h-16 text-white/80"
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
      </LinkTo>

      {{! Product Info }}
      <div class="flex flex-col flex-1 p-4">
        <LinkTo
          @route="products.product"
          @model={{@product.id}}
          class="group/link flex-1"
        >
          <h3
            id="product-{{@product.id}}-name"
            data-test-product-name
            class="font-semibold text-foreground group-hover/link:text-primary transition-colors line-clamp-2"
          >
            {{@product.name}}
          </h3>
        </LinkTo>
        <div class="mt-2 flex items-center justify-between">
          <span
            data-test-product-price
            class="text-lg font-bold text-foreground"
          >
            {{this.formattedPrice}}
          </span>
        </div>

        {{! Add to Cart Button }}
        <button
          data-test-add-to-cart
          type="button"
          aria-label="Add {{@product.name}} to cart"
          class="mt-4 w-full px-4 py-2.5 bg-primary text-primary-foreground font-medium rounded-lg hover:bg-primary/90 active:scale-[0.98] transition-all flex items-center justify-center gap-2"
          {{on "click" this.addToCart}}
        >
          <svg
            class="w-5 h-5"
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
        </button>
      </div>
    </article>
  </template>
}
