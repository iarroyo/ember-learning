import { LinkTo } from '@ember/routing';
import type { TOC } from '@ember/component/template-only';

interface Product {
  id: string;
  name: string;
  price: number;
  image?: string;
}

interface Signature {
  Args: {
    model: Product | null;
  };
  Element: HTMLDivElement;
}

const ProductTemplate: TOC<Signature> = <template>
  {{#if @model}}
    <div data-test-product-detail>
      <LinkTo @route="products" data-test-back-link>Back to Products</LinkTo>
      <h2 data-test-product-name>{{@model.name}}</h2>
      <p>Price: ${{@model.price}}</p>
    </div>
  {{else}}
    <div data-test-not-found>
      <p>Product not found</p>
      <LinkTo @route="products" data-test-back-link>Back to Products</LinkTo>
    </div>
  {{/if}}
</template>;

export default ProductTemplate;
