import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { action } from '@ember/object';

export interface ModalTriggerSignature {
  Args: {
    onOpen?: () => void;
    storeTrigger?: (element: HTMLElement) => void;
  };
  Blocks: {
    default: [];
  };
  Element: HTMLButtonElement;
}

class ModalTrigger extends Component<ModalTriggerSignature> {
  @action
  handleClick(event: MouseEvent): void {
    // Store reference to trigger element for focus return
    if (this.args.storeTrigger) {
      this.args.storeTrigger(event.currentTarget as HTMLElement);
    }
    if (this.args.onOpen) {
      this.args.onOpen();
    }
  }

  <template>
    <button
      type="button"
      {{on "click" this.handleClick}}
      ...attributes
    >
      {{yield}}
    </button>
  </template>
}

export { ModalTrigger };
