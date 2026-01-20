import type { TOC } from '@ember/component/template-only';

export interface ModalBodySignature {
  Args: Record<string, never>;
  Element: HTMLDivElement;
}

const ModalBody = <TOC<ModalBodySignature>>(
  <template>
    <div data-test-modal-body>
      {{yield}}
    </div>
  </template>
);

export { ModalBody };
