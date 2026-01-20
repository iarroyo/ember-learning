import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import type ShoppingCartService from 'ember-learning/services/shopping-cart';

interface CartSummarySignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

export class CartSummary extends Component<CartSummarySignature> {
  @service declare shoppingCart: ShoppingCartService;

  get itemCount(): number {
    return this.shoppingCart.itemCount;
  }

  get subtotal(): string {
    return `$${this.shoppingCart.subtotal.toFixed(2)}`;
  }

  get isEmpty(): boolean {
    return this.shoppingCart.isEmpty;
  }

  @action
  clearCart(): void {
    this.shoppingCart.clearCart();
  }

  <template>
    <div>
      <span data-test-item-count>{{this.itemCount}}</span>
      <span data-test-subtotal>{{this.subtotal}}</span>
      <button
        data-test-clear-cart
        type="button"
        {{on "click" this.clearCart}}
        disabled={{this.isEmpty}}
      >
        Clear Cart
      </button>
    </div>
  </template>;
}
