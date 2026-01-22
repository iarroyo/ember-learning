import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { waitForPromise } from '@ember/test-waiters';

type ButtonState = 'idle' | 'loading' | 'success' | 'error';

interface AsyncButtonSignature {
  Args: {
    onClick: () => Promise<void>;
    label?: string;
    loadingLabel?: string;
    successLabel?: string;
    errorLabel?: string;
    successDuration?: number;
  };
  Element: HTMLButtonElement;
}

export class AsyncButton extends Component<AsyncButtonSignature> {
  @tracked state: ButtonState = 'idle';

  get label(): string {
    return this.args.label ?? 'Submit';
  }

  get loadingLabel(): string {
    return this.args.loadingLabel ?? 'Loading...';
  }

  get successLabel(): string {
    return this.args.successLabel ?? 'Success!';
  }

  get errorLabel(): string {
    return this.args.errorLabel ?? 'Error';
  }

  get successDuration(): number {
    return this.args.successDuration ?? 1500;
  }

  get displayLabel(): string {
    switch (this.state) {
      case 'loading':
        return this.loadingLabel;
      case 'success':
        return this.successLabel;
      case 'error':
        return this.errorLabel;
      default:
        return this.label;
    }
  }

  get isDisabled(): boolean {
    return this.state === 'loading';
  }

  get isStateLoading(): boolean {
    return this.state === 'loading';
  }

  get isStateSuccess(): boolean {
    return this.state === 'success';
  }

  get isStateError(): boolean {
    return this.state === 'error';
  }

  @action
  async handleClick(): Promise<void> {
    if (this.state === 'loading') return;

    this.state = 'loading';

    try {
      // waitForPromise ensures test helpers wait for this operation
      await waitForPromise(this.args.onClick());
      this.state = 'success';

      // Reset to idle after showing success
      await waitForPromise(
        new Promise((resolve) => setTimeout(resolve, this.successDuration))
      );

      // Check if still in success state (component might be destroyed)
      if (this.state === 'success') {
        this.state = 'idle';
      }
    } catch {
      this.state = 'error';
    }
  }

  <template>
    <button
      data-test-async-button
      data-test-async-button-loading={{this.isStateLoading}}
      data-test-async-button-success={{this.isStateSuccess}}
      data-test-async-button-error={{this.isStateError}}
      type="button"
      disabled={{this.isDisabled}}
      aria-disabled={{this.isDisabled}}
      aria-busy={{this.isStateLoading}}
      {{on "click" this.handleClick}}
      ...attributes
    >
      <span aria-live="polite">{{this.displayLabel}}</span>
    </button>
  </template>
}
