import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import type Owner from '@ember/owner';

import { Button } from 'ember-learning/components/ui/button';

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
    <div class="flex items-center gap-2" role="group" aria-label="Counter">
      <Button
        @variant="outline"
        @size="icon-sm"
        data-test-decrement
        aria-label="Decrease count"
        {{on "click" this.decrement}}
      >
        −
      </Button>
      <span
        data-test-count
        class="text-xl font-semibold tabular-nums w-10 text-center"
        aria-live="polite"
        aria-atomic="true"
      >{{this.count}}</span>
      <Button
        @variant="outline"
        @size="icon-sm"
        data-test-increment
        aria-label="Increase count"
        {{on "click" this.increment}}
      >
        +
      </Button>
      <Button
        @variant="ghost"
        @size="sm"
        data-test-reset
        {{on "click" this.reset}}
      >
        Reset
      </Button>
    </div>
  </template>
}
