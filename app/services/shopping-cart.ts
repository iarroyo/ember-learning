import Service from '@ember/service';
import { tracked, cached } from '@glimmer/tracking';

export interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
}

export default class ShoppingCartService extends Service {
  @tracked items: CartItem[] = [];

  @cached
  get itemCount(): number {
    return this.items.reduce((sum, item) => sum + item.quantity, 0);
  }

  @cached
  get subtotal(): number {
    return this.items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  }

  get isEmpty(): boolean {
    return this.items.length === 0;
  }

  addItem(product: { id: string; name: string; price: number }): void {
    const existingItem = this.items.find(item => item.id === product.id);
    
    if (existingItem) {
      existingItem.quantity++;
    } else {
      this.items = [...this.items, {
        id: product.id,
        name: product.name,
        price: product.price,
        quantity: 1
      }];
    }
  }

  removeItem(id: string): void {
    this.items = this.items.filter(item => item.id !== id);
  }

  updateQuantity(id: string, quantity: number): void {
    if (quantity <= 0) {
      this.removeItem(id);
    } else {
      const item = this.items.find(item => item.id === id);
      if (item) {
        item.quantity = quantity;
        this.items = [...this.items]; // Trigger reactivity
      }
    }
  }

  clearCart(): void {
    this.items = [];
  }
}
