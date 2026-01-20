import type { TOC } from '@ember/component/template-only';
import { on } from '@ember/modifier';

export interface ModalHeaderSignature {
  Args: {
    title: string;
    titleId?: string;
    onClose?: () => void;
  };
  Element: HTMLDivElement;
}

const ModalHeader = <TOC<ModalHeaderSignature>>(
  <template>
    <div data-test-modal-header>
      <h2 data-test-modal-title id={{@titleId}}>{{@title}}</h2>
      {{#if @onClose}}
        <button
          data-test-modal-close
          type="button"
          {{on "click" @onClose}}
        >
          ×
        </button>
      {{/if}}
    </div>
  </template>
);

export { ModalHeader };
