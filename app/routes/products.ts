import Route from '@ember/routing/route';

interface Product {
  id: string;
  name: string;
  price: number;
  image?: string;
}

const mockProducts: Product[] = [
  { id: '1', name: 'Wireless Headphones', price: 99.99 },
  { id: '2', name: 'Mechanical Keyboard', price: 149.99 },
  { id: '3', name: 'Gaming Mouse', price: 79.99 },
];

export default class ProductsRoute extends Route {
  model(): Product[] {
    return mockProducts;
  }
}
