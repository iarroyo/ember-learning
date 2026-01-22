import { LinkTo } from '@ember/routing';
import type { TOC } from '@ember/component/template-only';
import { ProductCard } from 'ember-learning/components/product-card';
import { Button } from 'ember-learning/components/ui/button';
import { ThemeSwitcher } from 'ember-learning/components/theme-switcher';

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
  <div class="min-h-screen bg-background">
    {{! Navigation }}
    <nav class="bg-card border-b sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center">
            <Button
              @asChild={{true}}
              @variant="ghost"
              @class="p-0 hover:bg-transparent"
            >
              <:default as |b|>
                <LinkTo
                  @route="index"
                  class="{{b.classes}} flex items-center space-x-3 group"
                >
                  <div
                    class="w-10 h-10 bg-gradient-to-br from-orange-500 to-red-600 rounded-xl flex items-center justify-center shadow-lg group-hover:shadow-xl transition-shadow"
                  >
                    <span class="text-white font-bold text-lg">E</span>
                  </div>
                  <span class="text-xl font-bold text-foreground">Ember Learning</span>
                </LinkTo>
              </:default>
            </Button>
          </div>
          <div class="flex items-center space-x-2">
            <Button @asChild={{true}} @variant="ghost">
              <:default as |b|>
                <LinkTo @route="index" class={{b.classes}}>
                  Home
                </LinkTo>
              </:default>
            </Button>
            <Button @asChild={{true}} @variant="ghost">
              <:default as |b|>
                <LinkTo @route="demo" class={{b.classes}}>
                  Demo
                </LinkTo>
              </:default>
            </Button>
            <Button @variant="ghost" @class="text-primary">
              Products
            </Button>
            <ThemeSwitcher />
          </div>
        </div>
      </div>
    </nav>

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      {{! Header }}
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-foreground">Products</h1>
        <p class="text-muted-foreground mt-2">
          Browse our collection of premium products
        </p>
      </div>

      {{! Product Grid }}
      <div
        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6"
      >
        {{#each @model as |product|}}
          <div
            data-test-product-card
            class="bg-card rounded-lg border shadow-sm hover:shadow-md transition-shadow overflow-hidden"
          >
            <ProductCard @product={{product}} />
          </div>
        {{/each}}
      </div>

      {{! Empty State }}
      {{#unless @model.length}}
        <div class="text-center py-16">
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
              d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"
            />
          </svg>
          <h3 class="mt-4 text-lg font-medium text-foreground">No products found</h3>
          <p class="mt-2 text-muted-foreground">Check back later for new
            arrivals.</p>
        </div>
      {{/unless}}
    </div>

    {{outlet}}
  </div>
</template>;

export default ProductsTemplate;
