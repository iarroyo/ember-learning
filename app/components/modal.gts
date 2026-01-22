import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { hash } from '@ember/helper';
import { modifier } from 'ember-modifier';
import type { ComponentLike } from '@glint/template';
import type { TOC } from '@ember/component/template-only';

// ModalTrigger Component
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
    <button type="button" {{on "click" this.handleClick}} ...attributes>
      {{yield}}
    </button>
  </template>
}

// ModalHeader Component
export interface ModalHeaderSignature {
  Args: {
    title: string;
    titleId?: string;
    onClose?: () => void;
  };
  Element: HTMLDivElement;
}

const ModalHeader = <TOC<ModalHeaderSignature>><template>
  <div data-test-modal-header>
    <h2 data-test-modal-title id={{@titleId}}>{{@title}}</h2>
    {{#if @onClose}}
      <button
        data-test-modal-close
        type="button"
        aria-label="Close modal"
        {{on "click" @onClose}}
      >
        ×
      </button>
    {{/if}}
  </div>
</template>;

// ModalBody Component
export interface ModalBodySignature {
  Args: Record<string, never>;
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

const ModalBody = <TOC<ModalBodySignature>><template>
  <div data-test-modal-body>
    {{yield}}
  </div>
</template>;

// ModalFooter Component
export interface ModalFooterSignature {
  Args: Record<string, never>;
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}

const ModalFooter = <TOC<ModalFooterSignature>><template>
  <div data-test-modal-footer>
    {{yield}}
  </div>
</template>;

// Focus modifier
const focusOnInsert = modifier((element: HTMLElement) => {
  // Focus the first focusable element or the modal itself
  const focusableElements = element.querySelectorAll<HTMLElement>(
    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
  );
  if (focusableElements.length > 0) {
    focusableElements[0]!.focus();
  } else {
    element.setAttribute('tabindex', '-1');
    element.focus();
  }
});

// Main Modal Component
interface ModalSignature {
  Args: {
    isOpen?: boolean;
    size?: 'sm' | 'md' | 'lg';
    closeOnBackdropClick?: boolean;
    onClose?: () => void;
  };
  Blocks: {
    default: [
      {
        Trigger: ComponentLike<ModalTriggerSignature>;
        Header: ComponentLike<ModalHeaderSignature>;
        Body: ComponentLike<ModalBodySignature>;
        Footer: ComponentLike<ModalFooterSignature>;
        close: () => void;
        isOpen: boolean;
      },
    ];
  };
  Element: HTMLDivElement;
}

export class Modal extends Component<ModalSignature> {
  @tracked internalIsOpen = false;
  private triggerElement: HTMLElement | null = null;

  get isOpen(): boolean {
    return this.args.isOpen ?? this.internalIsOpen;
  }

  get sizeClass(): string {
    const size = this.args.size ?? 'md';
    return `modal__content--${size}`;
  }

  get titleId(): string {
    return `modal-title-${Math.random().toString(36).substr(2, 9)}`;
  }

  @action
  open(): void {
    this.internalIsOpen = true;
  }

  @action
  close(): void {
    if (this.args.onClose) {
      this.args.onClose();
    } else {
      this.internalIsOpen = false;
    }

    // Return focus to trigger
    if (this.triggerElement) {
      this.triggerElement.focus();
    }
  }

  @action
  handleBackdropClick(event: MouseEvent): void {
    if (
      this.args.closeOnBackdropClick !== false &&
      event.target === event.currentTarget
    ) {
      this.close();
    }
  }

  @action
  handleKeyDown(event: KeyboardEvent): void {
    if (event.key === 'Escape' && this.isOpen) {
      this.close();
    }
  }

  @action
  storeTrigger(element: HTMLElement): void {
    this.triggerElement = element;
  }

  <template>
    {{#let
      (component ModalTrigger onOpen=this.open storeTrigger=this.storeTrigger)
      (component ModalHeader titleId=this.titleId onClose=this.close)
      (component ModalBody)
      (component ModalFooter)
      as |Trigger Header Body Footer|
    }}
      {{yield
        (hash
          Trigger=Trigger
          Header=Header
          Body=Body
          Footer=Footer
          close=this.close
          isOpen=this.isOpen
        )
      }}

      {{#if this.isOpen}}
        <div
          data-test-modal
          role="dialog"
          aria-modal="true"
          aria-labelledby={{this.titleId}}
          {{on "keydown" this.handleKeyDown}}
          {{focusOnInsert}}
        >
          <div
            data-test-modal-backdrop
            class="modal-backdrop"
            {{on "click" this.handleBackdropClick}}
          >
            <div data-test-modal-content class={{this.sizeClass}}>
              {{yield
                (hash
                  Trigger=Trigger
                  Header=Header
                  Body=Body
                  Footer=Footer
                  close=this.close
                  isOpen=this.isOpen
                )
              }}
            </div>
          </div>
        </div>
      {{/if}}
    {{/let}}
  </template>
}
