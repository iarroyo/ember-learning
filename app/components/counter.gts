import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import type Owner from '@ember/owner';

interface CounterSignature {
  Args: {
    initialValue?: number;
  };
  Element: HTMLDivElement;
}

export class Counter extends Component<CounterSignature> {
  @tracked count: number;

  constructor(owner: Owner, args: CounterSignature['Args']) {
    super(owner, args);
    this.count = args.initialValue ?? 0;
  }

  get initialValue(): number {
    return this.args.initialValue ?? 0;
  }

  @action
  increment(): void {
    this.count++;
  }

  @action
  decrement(): void {
    this.count--;
  }

  @action
  reset(): void {
    this.count = this.initialValue;
  }

  <template>
    <div>
      <span data-test-count>{{this.count}}</span>
      <button data-test-increment type="button" {{on "click" this.increment}}>Increment</button>
      <button data-test-decrement type="button" {{on "click" this.decrement}}>Decrement</button>
      <button data-test-reset type="button" {{on "click" this.reset}}>Reset</button>
    </div>
  </template>;
}


