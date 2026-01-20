import { LinkTo } from '@ember/routing';

<template>
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
</template>
