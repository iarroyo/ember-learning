import Route from '@ember/routing/route';

interface Product {
  id: string;
  name: string;
  price: number;
  image?: string;
}

const mockProducts: Record<string, Product> = {
  '1': { id: '1', name: 'Wireless Headphones', price: 99.99 },
  '2': { id: '2', name: 'Mechanical Keyboard', price: 149.99 },
  '3': { id: '3', name: 'Gaming Mouse', price: 79.99 },
};

export default class ProductsProductRoute extends Route {
  async model(params: { product_id: string }): Promise<Product | null> {
    return mockProducts[params.product_id] || null;
  }
}
