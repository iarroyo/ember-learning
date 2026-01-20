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
    model: Product[];
  };
  Element: HTMLDivElement;
}

const ProductsTemplate: TOC<Signature> = <template>
  <div>
    <h1>Products</h1>
    <div>
      {{#each @model as |product|}}
        <div data-test-product-card>
          <LinkTo @route="products.product" @model={{product.id}} data-test-product-link>
            {{product.name}} - ${{product.price}}
          </LinkTo>
        </div>
      {{/each}}
    </div>
    {{outlet}}
  </div>
</template>;

export default ProductsTemplate;
