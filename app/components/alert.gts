import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

type AlertVariant = 'info' | 'success' | 'warning' | 'error';

interface AlertSignature {
  Args: {
    variant?: AlertVariant;
    dismissible?: boolean;
    onDismiss?: () => void;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

const variantClasses: Record<AlertVariant, string> = {
  info: 'bg-blue-100 text-blue-800 border-blue-300',
  success: 'bg-green-100 text-green-800 border-green-300',
  warning: 'bg-yellow-100 text-yellow-800 border-yellow-300',
  error: 'bg-red-100 text-red-800 border-red-300',
};

export class Alert extends Component<AlertSignature> {
  @tracked dismissedForVariant: AlertVariant | null = null;

  get variant(): AlertVariant {
    return this.args.variant ?? 'info';
  }

  get variantClasses(): string {
    return variantClasses[this.variant];
  }

  get isVisible(): boolean {
    // Only stay dismissed if dismissed for the current variant
    return this.dismissedForVariant !== this.variant;
  }

  @action
  dismiss(): void {
    if (this.args.onDismiss) {
      this.args.onDismiss();
    } else {
      // Track which variant was dismissed
      this.dismissedForVariant = this.variant;
    }
  }

  <template>
    {{#if this.isVisible}}
      <div
        data-test-alert
        class="p-4 rounded-lg border {{this.variantClasses}}"
        role="alert"
        ...attributes
      >
        <div class="flex items-center justify-between">
          <div>{{yield}}</div>
          {{#if @dismissible}}
            <button
              data-test-alert-dismiss
              type="button"
              class="ml-4 text-current opacity-70 hover:opacity-100"
              aria-label="Dismiss alert"
              {{on "click" this.dismiss}}
            >
              ×
            </button>
          {{/if}}
        </div>
      </div>
    {{/if}}
  </template>
}
