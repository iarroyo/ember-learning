import Component from '@glimmer/component';
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

  get productLink(): string {
    return `/products/${this.args.product.id}`;
  }

  @action
  addToCart(): void {
    this.shoppingCart.addItem({
      id: this.args.product.id,
      name: this.args.product.name,
      price: this.args.product.price
    });
  }

  <template>
    <div>
      {{#if @product.image}}
        <img data-test-product-image src={{@product.image}} alt={{@product.name}} />
      {{/if}}
      <a data-test-product-link href={{this.productLink}}>
        <div data-test-product-name>{{@product.name}}</div>
        <div data-test-product-price>{{this.formattedPrice}}</div>
      </a>
      <button data-test-add-to-cart type="button" {{on "click" this.addToCart}}>
        Add to Cart
      </button>
    </div>
  </template>;
}
