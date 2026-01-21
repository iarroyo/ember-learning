import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { cn } from 'ember-learning/lib/utils';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

interface TabsSignature {
  Args: {
    defaultValue?: string;
    value?: string;
    onValueChange?: (value: string) => void;
    class?: string;
  };
  Blocks: {
    default: [
      {
        List: typeof TabsList;
        Trigger: WithBoundArgs<typeof TabsTrigger, 'currentValue' | 'setValue'>;
        Content: WithBoundArgs<typeof TabsContent, 'currentValue'>;
        value: string;
        setValue: (value: string) => void;
      },
    ];
  };
  Element: HTMLDivElement;
}

class Tabs extends Component<TabsSignature> {
  @tracked currentValue?: string;

  get value() {
    return this.args.value ?? this.currentValue ?? this.args.defaultValue ?? '';
  }

  setValue = (value: string) => {
    this.currentValue = value;
    this.args.onValueChange?.(value);
  };

  <template>
    <div
      class={{cn "flex flex-col gap-2" @class}}
      data-slot="tabs"
      ...attributes
    >
      {{yield
        (hash
          List=TabsList
          Trigger=(component
            TabsTrigger currentValue=this.value setValue=this.setValue
          )
          Content=(component TabsContent currentValue=this.value)
          value=this.value
          setValue=this.setValue
        )
      }}
    </div>
  </template>
}

interface TabsListSignature {
  Args: {
    class?: string;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

const TabsList: TOC<TabsListSignature> = <template>
  <div
    class={{cn
      "bg-muted text-muted-foreground inline-flex h-9 w-fit items-center justify-center rounded-lg p-[3px]"
      @class
    }}
    data-slot="tabs-list"
    role="tablist"
    ...attributes
  >
    {{yield}}
  </div>
</template>;

interface TabsTriggerSignature {
  Args: {
    value: string;
    currentValue?: string;
    setValue?: (value: string) => void;
    class?: string;
    disabled?: boolean;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLButtonElement;
}

class TabsTrigger extends Component<TabsTriggerSignature> {
  get isActive() {
    return this.args.value === this.args.currentValue;
  }

  handleClick = () => {
    if (!this.args.disabled && this.args.setValue) {
      this.args.setValue(this.args.value);
    }
  };

  <template>
    <button
      aria-selected={{if this.isActive "true" "false"}}
      class={{cn
        "data-[state=active]:bg-background dark:data-[state=active]:text-foreground focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:outline-ring dark:data-[state=active]:border-input dark:data-[state=active]:bg-input/30 text-foreground dark:text-muted-foreground inline-flex h-[calc(100%-1px)] flex-1 items-center justify-center gap-1.5 rounded-md border border-transparent px-2 py-1 text-sm font-medium whitespace-nowrap transition-[color,box-shadow] focus-visible:ring-[3px] focus-visible:outline-1 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:shadow-sm [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"
        @class
      }}
      data-slot="tabs-trigger"
      data-state={{if this.isActive "active" "inactive"}}
      disabled={{@disabled}}
      role="tab"
      type="button"
      {{on "click" this.handleClick}}
      ...attributes
    >
      {{yield}}
    </button>
  </template>
}

interface TabsContentSignature {
  Args: {
    value: string;
    currentValue?: string;
    class?: string;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

class TabsContent extends Component<TabsContentSignature> {
  get isActive() {
    return this.args.value === this.args.currentValue;
  }

  <template>
    {{#if this.isActive}}
      <div
        class={{cn "flex-1 outline-none" @class}}
        data-slot="tabs-content"
        data-state={{if this.isActive "active" "inactive"}}
        role="tabpanel"
        tabindex="0"
        ...attributes
      >
        {{yield}}
      </div>
    {{/if}}
  </template>
}

export { Tabs, TabsList, TabsTrigger, TabsContent };
